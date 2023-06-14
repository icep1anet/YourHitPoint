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
  List<FlSpot> spots = [];
  double fontPosition = 48.5;
  Color barColor = const Color(0xFF32cd32);
  Color fontColor = Colors.white;
  DateTime? latestDataTime;
  double? minGraphX;
  double? maxGraphX;
  String activeLimitTime = "";

  void setHPspotsList(List<Map> dataList) {
    spots = createHPSpotsList(dataList);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  setTimerFunc(int time, Function func) {
    Timer.periodic(const Duration(seconds: 20), (timer) {
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
    String? userName = prefs.getString("userName");
    // String? avatarName = prefs.getString("avatarName");
    // String? avatarType = prefs.getString("avatarType");
    if (userName != null) logger.d("userName:$userName");
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  //現在のHPを変える
  void changeHP() {
    logger.d(hpNumber);
    if (hpNumber < 100) {
      // setState(() {
      // currentHP = hpNumber;
      // currentHP = hpList[hpNumber]["y"];
      // });
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
      hpNumber += 10;
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

  Future<void> fetchFirebaseData() async {
    logger.d("startttttt");
    DateTime now = DateTime.now();
    DateTime hoursAgo = now.add(const Duration(hours: 8) * -1);
    if (latestDataTime != null) {
      if (latestDataTime!.compareTo(hoursAgo) == 1) {
        hoursAgo = latestDataTime!;
        logger.d("latestDataTime:$latestDataTime");
      }
    }


    var url = Uri.https("o2nr395oib.execute-api.ap-northeast-1.amazonaws.com",
        "/default/get_HP_data", {
      "userId": "id_abcd",
      "startTimestamp": hoursAgo.toString(),
      "endTimestamp": now.toString()
    });
    var response = await http.get(url);
    logger.d(response.body);
    if (response.statusCode == 200) {
      // リクエストが成功した場合、レスポンスの内容を取得して表示します
      logger.d("成功しました！");
      logger.d(response.body);

      var responseMap = jsonDecode(response.body);
      logger.d("past:");
      logger.d(responseMap["past_spots"]);
      List tes1 = responseMap["past_spots"];
      List<Map<dynamic, dynamic>> tes2 = [];
      for (Map a in tes1) {
        tes2.add(a);
      }
      logger.d("daiichidannkai");
      List<FlSpot> tes = createHPSpotsList(tes2);
      logger.d(tes);

      logger.d("tes.length: ${tes.length}");
      logger.d("spots.length: ${spots.length}");
      if (spots.isNotEmpty && tes.isNotEmpty) {
        logger.d("spots is not Empty");
        spots.removeRange(0, tes.length - 1);
      }
      // for (int i = 0; i < tes.length; i++) {
      //   spots.add(tes[i]);
      // }
      // spots = tes;
      // spots.addAll(tes);

      imgUrl = responseMap["url"];
      spots = spots + tes;
      if (spots.isNotEmpty) {
        minGraphX = spots[0].x.toInt().toDouble();
      } else {
        minGraphX = null;
      }
      if (futureSpots.isNotEmpty) {
        maxGraphX = futureSpots.last.x.ceil().toDouble();
      } else {
        maxGraphX = null;
      }
      recordHighHP = responseMap["recordHighHP"];
      recordLowHP = responseMap["recordLowHP"];
      logger.d("spotsAfter: $spots");
      logger.d("spotsLengthAfter: ${spots.length}");
      //latestDataTimeの更新
      latestDataTime = now;
    } else {
      // リクエストが失敗した場合、エラーメッセージを表示します
      logger.d("Request failed with status: ${response.statusCode}");
    }
  }
}



  // // //responseを送ってfirebaseにデータ登録する
  // Future<void> fetchFirebaseData() async {
  //   logger.d("startttttt");
  //   DateTime now = DateTime.now();
  //   DateTime hoursAgo = now.add(const Duration(hours: 8) * -1);
  //   if (latestDataTime != null) {
  //     if (latestDataTime!.compareTo(hoursAgo) == 1) {
  //       hoursAgo = latestDataTime!;
  //       logger.d("latestDataTime:$latestDataTime");
  //     }
  //   }
  //   var url = Uri.https("o2nr395oib.execute-api.ap-northeast-1.amazonaws.com",
  //       "/default/get_HP_data", {
  //     "userId": "id_abcd",
  //     "startTimestamp": hoursAgo.toString(),
  //     "endTimestamp": now.toString()
  //   });
  //   var response = await http.get(url);
  //   logger.d(response.body);
  //   if (response.statusCode == 200) {
  //     // リクエストが成功した場合、レスポンスの内容を取得して表示します
  //     logger.d("成功しました！");
  //     logger.d(response.body);

  //     var responseMap = jsonDecode(response.body);
  //     logger.d("past:");
  //     logger.d(responseMap["past_spots"]);
  //     List pastTmp = responseMap["past_spots"];
  //     List<Map<dynamic, dynamic>> pastTmp2 = [];
  //     for (Map map in pastTmp) {
  //       pastTmp2.add(map);
  //     }
  //     List futureTmp = responseMap["future_spots"];
  //     List<Map<dynamic, dynamic>> futureTmp2 = [];
  //     for (Map map in futureTmp) {
  //       futureTmp2.add(map);
  //     }
  //     logger.d("daiichidannkai");
  //     List<FlSpot> pastTmp3 = createFlSpotList(pastTmp2);
  //     List<FlSpot> futureTmp3 = createFlSpotList(futureTmp2);
  //     logger.d("pastTmp3: $pastTmp3");
  //     logger.d("pastTmp3.length: ${pastTmp3.length}");
  //     logger.d("spots.length: ${spots.length}");
  //     if (spots.isNotEmpty && pastTmp3.isNotEmpty) {
  //       logger.d("spots is not Empty");
  //       spots.removeRange(0, pastTmp3.length - 1);
  //     } else {
  //       logger.d("spots is Empty or tes is Empty");
  //     }
  //     setState(() {
  //       imgUrl = responseMap["url"];
  //       spots = spots + pastTmp3;
  //       if (spots.isNotEmpty) {
  //         minX = spots[0].x.toInt().toDouble();
  //         logger.d("minx更新: ${minX.toString()}");
  //       } else {
  //         minX = null;
  //       }
  //       futureSpots = futureTmp3;
  //       logger.d("futureSpots: $futureSpots");
  //       if (futureSpots.isNotEmpty) {
  //         maxX = futureSpots.last.x.ceil().toDouble();
  //         logger.d("maxx更新: ${maxX.toString()}");
  //       } else {
  //         maxX = null;
  //       }
  //       recordHighHP = responseMap["recordHighHP"];
  //       recordLowHP = responseMap["recordLowHP"];
  //       activeLimitTime = responseMap["activeLimitTime"];
  //     });
  //     logger.d("spotsAfter: $spots");
  //     logger.d("spotsLengthAfter: ${spots.length}");
  //     //latestDataTimeの更新
  //     latestDataTime = now;
  //     hpNumber = 0;
  //   } else {
  //     // リクエストが失敗した場合、エラーメッセージを表示します
  //     logger.d("Request failed with status: ${response.statusCode}");
  //   }
  // }
