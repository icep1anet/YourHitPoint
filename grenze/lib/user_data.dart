import "dart:async";
import 'package:flutter/material.dart';
import "package:fl_chart/fl_chart.dart";
import "package:logger/logger.dart";
import "package:shared_preferences/shared_preferences.dart";
import "dart:convert";
import "package:http/http.dart" as http;

import 'hp_graph.dart';

var logger = Logger();
const Map test = {"x": 3, "y": 4};

class UserDataProvider with ChangeNotifier {
  int pageIndex = 0;
  int currentHP = 100;
  int hpNumber = 0;
  String? avatarName;
  String? avatarType = "猫";
  String? userName;
  String? userId;
  double recordHighHP = 0;
  double recordLowHP = 0;
  String? imgUrl;
  List<FlSpot> futureSpots = [];
  List<FlSpot> pastSpots = [];
  double fontPosition = 48.5;
  Color barColor = const Color(0xFF32cd32);
  Color fontColor = Colors.white;
  DateTime? latestDataTime;
  double? minGraphX;
  double? maxGraphX;
  double? minGraphY;
  double? maxGraphY;
  String activeLimitTime = "";
  List friendDataList = [];
  bool? hasData;

  void setHPSpotsList(List<Map> dataList) {
    pastSpots = createHPSpotsList(dataList);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  void setTimerFunc(int time, Function func) {
    Timer.periodic(Duration(seconds: time), (timer) {
      func();
    });
  }

  //debug
  void setZeroHP() {
    logger.d("reset!!!!!!!");
    hpNumber = 0;
    // このモデルをlistenしているWidgetに対してrebuild指示
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  void setPageIndex(int index) {
    pageIndex = index;
    // rebuild指示は必要ない
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  Future<void> setItemToSharedPref(
      List<String> itemNames, List<dynamic> items) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    for (int i = 0; i < itemNames.length; i++) {
      prefs.setString(itemNames[i], items[i]);
      if (itemNames[i] == "userId") {
        userId = items[i];
        WidgetsBinding.instance.addPostFrameCallback((_) {
          notifyListeners();
        });
      }
    }
  }

  Future<void> setUserId(newId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("userId", newId);
    userId = prefs.getString("userId");
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  Future<void> setFriendDataList() async {
    Map friendResponseBody = await fetchFriendData();
    friendDataList = friendResponseBody["friendDataList"];
  }

  Future<void> refreshUserID(String id) async {
    await setUserId(id);
    await setFriendDataList();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  Future<void> initMain() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString("userId");
    if (userId != null) {
      await updateUserData();
    }
    changeHP();
  }

  // debug
  // useridをprefsから消す
  Future<void> initRemoveUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("userId");
    userId = null;
    // for (int i = 0; i <= 10; i++) {
    //   prefs.remove("userId" + i.toString());
    // }
    notifyListeners();
  }

  //現在のHPを変える
  void changeHP() {
    if (hpNumber < futureSpots.length) {
      currentHP = futureSpots[hpNumber].y.toInt();
      if (80 < currentHP) {
        barColor = const Color(0xFF32cd32);
        fontColor = Colors.white;
        fontPosition = 60;
      } else if (40 < currentHP && currentHP <= 80) {
        barColor = const Color(0xff00ff7f);
        fontColor = Colors.white;
        fontPosition = 60;
      } else if (30 < currentHP && currentHP <= 40) {
        barColor = const Color(0xff00ff7f);
        fontColor = Colors.black;
        fontPosition = 0;
      } else if (0 < currentHP && currentHP <= 30) {
        barColor = const Color(0xffffd700);
        fontColor = Colors.black;
        fontPosition = 0;
      } else {
        barColor = const Color(0xffdc143c);
        fontColor = Colors.black;
        fontPosition = 0;
      }
      hpNumber += 1;
    } else {}
    notifyListeners();
  }

  Map calculateBeforeFetchedDatetime() {
    //リクエストのための時間計算
    logger.d("start before fetch time");
    DateTime now = DateTime.now();
    DateTime hoursAgo = now.add(const Duration(hours: 8) * -1);
    if (latestDataTime != null) {
      if (latestDataTime!.compareTo(hoursAgo) == 1) {
        hoursAgo = latestDataTime!;
      }
    }
    var res = {};
    res["hoursAgo"] = hoursAgo;
    res["now"] = now;
    return res;
  }

  void removePastSpotsData(List<FlSpot> pastTmpSpots) {
    //spotsにすでにデータがある場合は取ってきた新しい過去データの数だけ昔のspotsのデータをremove
    if (pastSpots.isNotEmpty && pastTmpSpots.isNotEmpty) {
      logger.d("spots is not Empty");
      //pastSpotsからremoveするデータの個数を計算
      // 32個に保つために 32 = 現在の個数 + 入ってくる個数 - 取り除く個数
      // <=> 取り除く個数 = 現在の個数 + 入ってくる個数 -32
      int removeCount = pastTmpSpots.length + pastSpots.length - 32;
      if (removeCount > 0) {
        pastSpots.removeRange(0, removeCount);
      }
    } else {
      logger.d("spots is Empty or tes is Empty");
    }
  }

  void updateMinMaxSpots() {
    //pastSpotsの0番目のデータからminxをとる
    if (pastSpots.isNotEmpty) {
      minGraphX = pastSpots.first.x.floor().toDouble();
      //maxYの値を５の倍数で切り上げる(例:32.4 -> 35.0)
      maxGraphY = pastSpots.first.y;
      double tmpMaxY = maxGraphY!;
      maxGraphY = ((maxGraphY! / 10).round().toDouble()) * 10;
      if (maxGraphY! < tmpMaxY) {
        maxGraphY = maxGraphY! + 5.0;
      }
    } else {
      minGraphX = null;
      maxGraphY = null;
    }
    logger.d("futureSpots: $futureSpots");
    //futureSpotsの最後のデータからmaxXをとる
    if (futureSpots.isNotEmpty) {
      maxGraphX = futureSpots.last.x.ceil().toDouble();
      //maxYの値を５の倍数で切り下げる(例:32.4 -> 30.0)
      minGraphY = futureSpots.last.y;
      double tmpMinY = minGraphY!;
      minGraphY = ((minGraphY! / 10).round().toDouble()) * 10;
      if (minGraphY! > tmpMinY) {
        minGraphY = minGraphY! - 5.0;
      }
    } else {
      maxGraphX = null;
      minGraphY = null;
    }
  }

  Future<void> updateUserData() async {
    Map befFetchedtime = calculateBeforeFetchedDatetime();
    DateTime hoursAgo = befFetchedtime["hoursAgo"];
    DateTime now = befFetchedtime["now"];
    Map responseBody = await fetchFirebaseData(hoursAgo, now);
    List<FlSpot> pastTmpSpots = convertHPSpotsList(responseBody["past_spots"]);
    futureSpots = convertHPSpotsList(responseBody["future_spots"]);
    removePastSpotsData(pastTmpSpots);
    pastSpots += pastTmpSpots;
    logger.d("pastSpots: $pastSpots");

    updateMinMaxSpots();
    imgUrl = responseBody["url"];
    recordHighHP = responseBody["recordHighHP"];
    recordLowHP = responseBody["recordLowHP"];
    activeLimitTime = responseBody["activeLimitTime"];
    await setFriendDataList();
    //latestDataTimeの更新
    latestDataTime = now;
    hpNumber = 0;
    logger.d("Done!");
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  Future<Map> fetchFriendData() async {
    //リクエスト
    var url = Uri.https("3fk5goov13.execute-api.ap-northeast-1.amazonaws.com",
        "/default/get_friend_data_yourHP", {
      "userId": userId,
    });
    var response = await http.get(url);
    logger.d("friendbody: ${response.body}");
    //リクエストの返り値をマップ形式に変換
    var responseBody = jsonDecode(response.body);
    //リクエスト成功時
    if (response.statusCode == 200) {
      // リクエストが成功した場合、レスポンスの内容を取得して表示します
      logger.d("frined成功しました!");
    } else {
      // リクエストが失敗した場合、エラーメッセージを表示します
      logger.d("Request failed with status: $responseBody");
    }
    return responseBody;
  }

  Future<Map> fetchFirebaseData(DateTime hoursAgo, DateTime now) async {
    //リクエスト
    var url = Uri.https("o2nr395oib.execute-api.ap-northeast-1.amazonaws.com",
        "/default/get_HP_data", {
      "userId": userId,
      "startTimestamp": hoursAgo.toString(),
      "endTimestamp": now.toString()
    });
    var response = await http.get(url);
    logger.d("response.body: ${response.body}");
    //リクエストの返り値をマップ形式に変換
    var responseBody = jsonDecode(response.body);
    //リクエスト成功時
    if (response.statusCode == 200) {
      // リクエストが成功した場合、レスポンスの内容を取得して表示します
      logger.d("成功しました！");
    } else {
      // リクエストが失敗した場合、エラーメッセージを表示します
      logger.d("Request failed with status: ${responseBody.statusCode}");
    }
    return responseBody;
  }

//responseを送ってfirebaseにデータ登録する
  Future<Map> registerFirebase(
      isRegistered, inputUserName, inputAvatarName) async {
    isRegistered = true;
    logger.d("register start");
    var url = Uri.https("vignp7m26e.execute-api.ap-northeast-1.amazonaws.com",
        "/default/register_firebase_yourHP", {
      "userName": inputUserName,
      "avatarName": inputAvatarName,
      "avatarType": avatarType
    });
    try {
      var response = await http.get(url);
      logger.d("register.body: ${response.body}");
      if (response.statusCode == 200) {
        // リクエストが成功した場合、レスポンスの内容を取得して表示します
        var responseMap = jsonDecode(response.body);
        userId = responseMap["userId"];
        logger.d(userId);
        // if (!mounted) return;
        setItemToSharedPref(["userId", "userName", "avatarName", "avatarType"],
            [userId!, inputUserName, inputAvatarName, avatarType]);
      } else {
        // リクエストが失敗した場合、エラーメッセージを表示します
        logger.d("Request failed with status: $response");
        isRegistered = false;
        return {"isCompleted": false, "error": response};
      }
      return {"isCompleted": true};
    } catch (e) {
      isRegistered = false;
      return {"isCompleted": false, "error": e};
    }
  }
}
