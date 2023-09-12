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
  String? avatarName = "Pochi";
  String? avatarType = "hukurou";
  String? userName = "Yamada";
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
  int maxSleepDuration = 0;
  int maxDayHP = 100;
  int maxTotalDaySteps = 0;
  double hpPercent = 100;
  bool finishMain = false;
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
    await updateUserData();
    notifyListeners();
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
      hpPercent = (currentHP / maxDayHP) * 100;
      if (80 < hpPercent) {
        barColor = const Color(0xFF32cd32);
        fontColor = Colors.white;
        fontPosition = 60;
      } else if (40 < hpPercent && hpPercent <= 80) {
        barColor = const Color(0xff00ff7f);
        fontColor = Colors.white;
        fontPosition = 60;
      } else if (30 < hpPercent && hpPercent <= 40) {
        barColor = const Color(0xff00ff7f);
        fontColor = Colors.black;
        fontPosition = 0;
      } else if (0 < hpPercent && hpPercent <= 30) {
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
    logger.d(now);
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
      maxGraphY = pastSpots.first.y;
      //pastSpotsのyデータの最大値をmaxGraghYとする
      for (int i = 0; i < pastSpots.length; i++) {
        if (maxGraphY! < pastSpots[i].y) {
          maxGraphY = pastSpots[i].y;
        }
      }
      //maxYの値を５の倍数で切り上げる(例:32.4 -> 35.0)
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
      minGraphY = futureSpots.last.y;
      //pastSpotsとfutureSpotsのyデータの最小値をminGraghYとする
      for (int i = 0; i < futureSpots.length; i++) {
        if (minGraphY! > futureSpots[i].y) {
          minGraphY = futureSpots[i].y;
        }
      }
      if (pastSpots.isNotEmpty) {
        for (int i = 0; i < pastSpots.length; i++) {
          if (minGraphY! > pastSpots[i].y) {
            minGraphY = pastSpots[i].y;
          }
        }
      }
      //maxYの値を５の倍数で切り下げる(例:32.4 -> 30.0)
      double tmpMinY = minGraphY!;
      minGraphY = ((minGraphY! / 10).round().toDouble()) * 10;
      if (minGraphY! > tmpMinY) {
        minGraphY = minGraphY! - 5.0;
      }
    } else {
      maxGraphX = null;
      minGraphY = null;
    }
    //yの最大と最小に100以上の差がある時グラフが突き出す分の幅を持たせる
    if (maxGraphY != null && minGraphY != null) {
      if (maxGraphY! - minGraphY! >= 100) {
        double yMargin = 20.0;
        maxGraphY = maxGraphY! + yMargin;
        minGraphY = minGraphY! - yMargin;
      }
    }
  }

  Future<void> updateUserData() async {
    Map befFetchedtime = calculateBeforeFetchedDatetime();
    DateTime hoursAgo = befFetchedtime["hoursAgo"];
    DateTime now = befFetchedtime["now"];
    Map responseBody = await fetchFirebaseData(hoursAgo, now);
    if (!responseBody.containsKey("past_spots")) {
      return;
    }
    List<FlSpot> pastTmpSpots = convertHPSpotsList(responseBody["past_spots"]);
    futureSpots = convertHPSpotsList(responseBody["future_spots"]);
    removePastSpotsData(pastTmpSpots);
    pastSpots += pastTmpSpots;
    logger.d("pastSpots: $pastSpots");

    updateMinMaxSpots();
    imgUrl = responseBody["url"];
    recordHighHP = responseBody["recordHighHP"].toDouble();
    recordLowHP = responseBody["recordLowHP"].toDouble();
    activeLimitTime = responseBody["activeLimitTime"];
    maxSleepDuration = responseBody["maxSleepDuration"];
    maxDayHP = responseBody["maxDayHP"];
    maxTotalDaySteps = responseBody["maxTotalDaySteps"];
    await setFriendDataList();
    //latestDataTimeの更新
    latestDataTime = now;
    hpNumber = 0;
    logger.d("Done!");
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  Future<void> initMain() async {
    ///アバター名表示のためデバイスで1度だけ実行したら消していいです
    ///ローカルのsharedpreferenceにデータを書き込み
    ///普通ならregister時にローカルにデータが書き込まれるが、今デバックでuserIdだけ無理やり書き換えてるからそれ以外のデータがローカルになく、アバター名を表示できないので一度この処理を行う
    // await setItemToSharedPref(
    //     ["userId", "userName", "avatarName", "avatarType"],
    //     ["id_abcd", "Tom", "マルオ", "wani"]);
    // await initRemoveUserId();
    await getLocalData();
    if (userId != null) {
      logger.d("userId != null");
      await updateUserData();
      changeHP();
    } else {
      logger.d("userId == null");
    }
    finishMain = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
    // await updateUserData();
    // changeHP();
  }

  //Sharedpreferenceにあるユーザデータを取得
  Future<void> getLocalData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString("userId");
    userName = prefs.getString("userName");
    avatarName = prefs.getString("avatarName");
    avatarType = prefs.getString("avatarType");
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
      logger.d("Request failed with status: $responseBody");
    }
    return responseBody;
  }

//responseを送ってfirebaseにデータ登録する
  Future<Map> registerFirebase(isRegistered, inputEmail, inputPassword) async {
    isRegistered = true;
    logger.d("register start");
    var url = Uri.https("vignp7m26e.execute-api.ap-northeast-1.amazonaws.com",
        "/default/register_firebase_yourHP", {
      "email": inputEmail,
      "password": inputPassword,
      "userName": userName,
      "avatarName": avatarName,
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
            [userId!, userName, avatarName, avatarType]);
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
