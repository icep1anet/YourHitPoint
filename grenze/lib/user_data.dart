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
  String? avatarType;
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
  String activeLimitTime = "";
  List friendDataList = [];

  void setHPSpotsList(List<Map> dataList) {
    pastSpots = createHPSpotsList(dataList);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  setTimerFunc(int time, Function func) {
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

  // debug
  // useridをprefsから消す
  void initRemoveUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("userId");
    userId = null;
    // for (int i = 0; i <= 10; i++) {
    //   prefs.remove("userId" + i.toString());
    // }
    notifyListeners();
  }

  void setPageIndex(int index) {
    pageIndex = index;
    // rebuild指示は必要ない
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  void setItemToSharedPref(List<String> itemNames, List<dynamic> items) async {
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

  //ローカルdbからuserIdを取ってくる&debug
  void getPrefItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString("userId");
    // String? userName = prefs.getString("userName");
    // String? avatarName = prefs.getString("avatarName");
    // String? avatarType = prefs.getString("avatarType");
    // if (userName != null) logger.d("userName:$userName");
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  void setUserId(newId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("userId", newId);
    userId = prefs.getString("userId");
    logger.d(userId);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  Map calculateBeforeFetchedDatetime() {
    //リクエストのための時間計算
    logger.d("start before fetch time");
    DateTime now = DateTime.now();
    DateTime hoursAgo = now.add(const Duration(hours: 8) * -1);
    if (latestDataTime != null) {
      if (latestDataTime!.compareTo(hoursAgo) == 1) {
        hoursAgo = latestDataTime!;
        logger.d("latestDataTime:$latestDataTime");
      }
    }
    var res = {};
    res["hoursAgo"] = hoursAgo;
    res["now"] = now;
    return res;
  }

  Future<Map> fetchFirebaseData(DateTime hoursAgo, DateTime now) async {
    //リクエスト
    var url = Uri.https("o2nr395oib.execute-api.ap-northeast-1.amazonaws.com",
        "/default/get_HP_data", {
      "userId": "id_abcd",
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
      // logger.d(response.body);

      // logger.d("past:");
      // logger.d(responseBody["past_spots"]);
    } else {
      // リクエストが失敗した場合、エラーメッセージを表示します
      logger.d("Request failed with status: ${responseBody.statusCode}");
    }
    return responseBody;
  }

  void removePastSpotsData(List<FlSpot> pastTmpSpots) {
    //spotsにすでにデータがある場合は取ってきた新しい過去データの数だけ昔のspotsのデータをremove
    if (pastSpots.isNotEmpty && pastTmpSpots.isNotEmpty) {
      logger.d("spots is not Empty");
      pastSpots.removeRange(0, pastTmpSpots.length - 1);
    } else {
      logger.d("spots is Empty or tes is Empty");
    }
  }

  void updateMinMaxSpots() {
    //pastSpotsの0番目のデータからminxをとる
    if (pastSpots.isNotEmpty) {
      minGraphX = pastSpots.first.x.floor().toDouble();
    } else {
      minGraphX = null;
    }
    logger.d("futureSpots: $futureSpots");
    //futureSpotsの最後のデータからmaxXをとる
    if (futureSpots.isNotEmpty) {
      maxGraphX = futureSpots.last.x.ceil().toDouble();
    } else {
      maxGraphX = null;
    }
  }

  updateUserData()  async {
    Map befFetchedtime = calculateBeforeFetchedDatetime();
    DateTime hoursAgo = befFetchedtime["hoursAgo"];
    DateTime now = befFetchedtime["now"];
    fetchFirebaseData(hoursAgo, now).then((responseBody) {
      logger.d("responseBody: $responseBody");
      // logger.d("pastspot: ${responseBody["past_spots"]}");
      List<FlSpot> pastTmpSpots = convertHPSpotsList(responseBody["past_spots"]);
      logger.d("1");

      futureSpots = convertHPSpotsList(responseBody["future_spots"]);
      logger.d("2");

      removePastSpotsData(pastTmpSpots);
      logger.d("3");
      pastSpots += pastTmpSpots;

      updateMinMaxSpots();
      imgUrl = responseBody["url"];
      recordHighHP = responseBody["recordHighHP"];
      recordLowHP = responseBody["recordLowHP"];
      activeLimitTime = responseBody["activeLimitTime"];
    });
    // fetchFriendData(userId!).then((responseBody) {
    //   friendDataList = responseBody["friendDataList"];
    // });
    //latestDataTimeの更新
    latestDataTime = now;
    hpNumber = 0;
    logger.d("Done!");
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  Future<Map> fetchFriendData(String userId) async {
    //リクエスト
    var url = Uri.https("o2nr395oib.execute-api.ap-northeast-1.amazonaws.com",
        "/default/get_HP_data", {
      "userId": userId,
    });
    var response = await http.get(url);
    logger.d(response.body);
    //リクエストの返り値をマップ形式に変換
    var responseBody = jsonDecode(response.body);
    //リクエスト成功時
    if (response.statusCode == 200) {
      // リクエストが成功した場合、レスポンスの内容を取得して表示します
      logger.d("frined成功しました!");
      logger.d(response.body);
    } else {
      // リクエストが失敗した場合、エラーメッセージを表示します
      logger.d("Request failed with status: ${responseBody.statusCode}");
    }
    return responseBody;
  }



}

