import "dart:async";
import 'package:flutter/material.dart';
import "package:fl_chart/fl_chart.dart";
import "package:logger/logger.dart";
import "package:shared_preferences/shared_preferences.dart";
import "dart:convert";
import "package:http/http.dart" as http;

import 'utils/hp_graph.dart';

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
  Color barColor = const Color.fromARGB(255, 0, 226, 113);
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
  int experienceLevel = 15;
  int experiencePoint = 360;

  // List<dynamic> testPastSpots = [
  // {'x': 3.0, 'y': 57.78055555555558},
  // {'x': 3.0833333333333335, 'y': 57.651111111111135},
  // {'x': 3.1666666666666665, 'y': 57.52055555555558},
  // {'x': 3.25, 'y': 57.52055555555558},
  // {'x': 3.4333333333333336, 'y': 57.52055555555558},
  // {'x': 3.5, 'y': 57.38722222222225},
  // {'x': 3.5833333333333335, 'y': 57.253888888888916},
  // {'x': 3.6666666666666665, 'y': 57.10722222222225},
  // {'x': 3.75, 'y': 57.10722222222225},
  // {'x': 3.9333333333333336, 'y': 57.10722222222225},
  // {'x': 3.9833333333333334, 'y': 56.976666666666695},
  // {'x': 4.066666666666666, 'y': 56.84500000000003},
  // {'x': 4.15, 'y': 56.71388888888892},
  // {'x': 4.233333333333333, 'y': 56.71388888888892},
  // {'x': 4.433333333333334, 'y': 56.71388888888892},
  // {'x': 4.483333333333333, 'y': 56.56666666666669},
  // {'x': 4.566666666666666, 'y': 56.434444444444466},
  // {'x': 4.65, 'y': 56.282592592592614},
  // {'x': 4.733333333333333, 'y': 56.282592592592614},
  // {'x': 4.933333333333334, 'y': 56.282592592592614},
  // {'x': 5.0, 'y': 56.15648148148151},
  // {'x': 5.083333333333333, 'y': 56.029259259259284},
  // {'x': 5.166666666666667, 'y': 55.901481481481504},
  // {'x': 5.25, 'y': 55.901481481481504},
  // {'x': 5.433333333333334, 'y': 55.901481481481504},
  // {'x': 5.5, 'y': 55.76537037037039},
  // {'x': 5.583333333333333, 'y': 55.632592592592616},
  // {'x': 5.666666666666667, 'y': 55.49481481481484},
  // {'x': 5.75, 'y': 55.49481481481484},
  // {'x': 5.933333333333334, 'y': 55.49481481481484},
  // {'x': 6.0, 'y': 55.370925925925945},
  // {'x': 6.083333333333333, 'y': 55.2464814814815},
  // {'x': 6.166666666666667, 'y': 55.10425925925928},
  // {'x': 6.25, 'y': 55.10425925925928},
  // {'x': 6.433333333333334, 'y': 55.10425925925928},
  // {'x': 6.5, 'y': 54.98203703703706},
  // {'x': 6.583333333333333, 'y': 54.85000000000002},
  // {'x': 6.666666666666667, 'y': 54.72666666666669},
  // {'x': 6.75, 'y': 54.72666666666669},
  // {'x': 6.933333333333334, 'y': 54.58944444444447},
  // {'x': 7.016666666666667, 'y': 54.459444444444465},
  // {'x': 7.1, 'y': 54.33000000000002},
  // {'x': 7.183333333333334, 'y': 54.19055555555558},
  // {'x': 7.266666666666667, 'y': 54.19055555555558},
  // {'x': 7.433333333333334, 'y': 54.19055555555558},
  // {'x': 7.5, 'y': 54.19055555555558},
  // {'x': 7.583333333333333, 'y': 54.032222222222245},
  // {'x': 7.666666666666667, 'y': 53.873888888888914},
  // {'x': 7.75, 'y': 53.71555555555558},
  // {'x': 7.933333333333334, 'y': 53.71555555555558},
  // {'x': 7.983333333333333, 'y': 92.81888888888889},
  // {'x': 8.066666666666666, 'y': 92.65944444444445},
  // {'x': 8.15, 'y': 92.47833333333334},
  // {'x': 8.233333333333333, 'y': 92.28166666666667},
  // {'x': 8.316666666666666, 'y': 92.09833333333333},
  // {'x': 8.4, 'y': 91.86444444444444},
  // {'x': 8.483333333333333, 'y': 91.62444444444445},
  // {'x': 8.566666666666666, 'y': 91.38444444444445},
  // {'x': 8.65, 'y': 91.05277777777779},
  // {'x': 8.733333333333333, 'y': 90.65833333333335},
  // {'x': 8.816666666666666, 'y': 90.37870370370372},
  // {'x': 8.9, 'y': 89.9038888888889},
  // {'x': 8.983333333333333, 'y': 89.4425925925926},
  // {'x': 9.066666666666666, 'y': 89.19925925925926},
  // {'x': 9.15, 'y': 88.96370370370371},
  // {'x': 9.233333333333333, 'y': 88.72481481481482},
  // {'x': 9.316666666666666, 'y': 88.48148148148148},
  // {'x': 9.4, 'y': 88.25648148148149},
  // {'x': 9.483333333333333, 'y': 87.9751851851852},
  // {'x': 9.566666666666666, 'y': 87.64074074074075},
  // {'x': 9.65, 'y': 87.39555555555557},
  // {'x': 9.733333333333333, 'y': 86.88203703703705},
  // {'x': 9.816666666666666, 'y': 86.45185185185187},
  // {'x': 9.9, 'y': 86.1751851851852},
  // {'x': 9.983333333333333, 'y': 85.92259259259261},
//   {'x': 10.066666666666666, 'y': 85.68314814814816},
//   {'x': 10.15, 'y': 85.43962962962965},
//   {'x': 10.233333333333333, 'y': 85.20740740740743},
//   {'x': 10.316666666666666, 'y': 84.98851851851855},
//   {'x': 10.4, 'y': 84.75629629629633},
//   {'x': 10.483333333333333, 'y': 84.532962962963},
//   {'x': 10.566666666666666, 'y': 84.31907407407411},
//   {'x': 10.65, 'y': 84.10018518518523},
//   {'x': 10.733333333333333, 'y': 83.88240740740744},
//   {'x': 10.816666666666666, 'y': 83.6616666666667},
//   {'x': 10.9, 'y': 83.45092592592596},
//   {'x': 10.983333333333333, 'y': 83.2403703703704},
//   {'x': 11.066666666666666, 'y': 83.02944444444448},
//   {'x': 11.15, 'y': 82.812962962963},
//   {'x': 11.233333333333333, 'y': 82.61574074074078},
//   {'x': 11.316666666666666, 'y': 82.41462962962966},
//   {'x': 11.4, 'y': 82.21185185185188},
//   {'x': 11.483333333333333, 'y': 82.01074074074076},
//   {'x': 11.566666666666666, 'y': 81.80592592592595},
//   {'x': 11.65, 'y': 81.6053703703704},
//   {'x': 11.733333333333333, 'y': 81.40296296296299},
//   {'x': 11.816666666666666, 'y': 81.20129629629632},
//   {'x': 11.9, 'y': 80.98833333333336},
//   {'x': 11.983333333333333, 'y': 80.77888888888891},
//   {'x': 12.066666666666666, 'y': 80.55055555555558},
//   {'x': 12.15, 'y': 80.30203703703705},
//   {'x': 12.233333333333333, 'y': 80.06000000000002},
//   {'x': 12.316666666666666, 'y': 79.85055555555557},
//   {'x': 12.4, 'y': 79.64555555555557},
//   {'x': 12.483333333333333, 'y': 79.3790740740741},
//   {'x': 12.566666666666666, 'y': 79.12537037037039},
//   {'x': 12.65, 'y': 78.90925925925929},
//   {'x': 12.733333333333333, 'y': 78.67870370370373},
//   {'x': 12.816666666666666, 'y': 78.47981481481484},
//   {'x': 12.9, 'y': 78.28370370370374},
//   {'x': 12.983333333333333, 'y': 78.0803703703704},
//   {'x': 13.066666666666666, 'y': 77.8753703703704},
//   {'x': 13.15, 'y': 77.67148148148152},
//   {'x': 13.233333333333333, 'y': 77.45037037037041},
//   {'x': 13.316666666666666, 'y': 77.24370370370374},
//   {'x': 13.4, 'y': 77.04259259259263},
//   {'x': 13.483333333333333, 'y': 76.82907407407411},
//   {'x': 13.566666666666666, 'y': 76.61500000000004},
//   {'x': 13.65, 'y': 76.40574074074078},
//   {'x': 13.733333333333333, 'y': 76.20462962962966},
//   {'x': 13.816666666666666, 'y': 75.9940740740741},
//   {'x': 13.9, 'y': 75.79185185185189},
//   {'x': 13.983333333333333, 'y': 75.58685185185189},
//   {'x': 14.066666666666666, 'y': 75.38462962962967},
//   {'x': 14.15, 'y': 75.17981481481486},
//   {'x': 14.233333333333333, 'y': 74.97648148148153},
//   {'x': 14.316666666666666, 'y': 74.77203703703708},
//   {'x': 14.4, 'y': 74.56981481481486},
//   {'x': 14.483333333333333, 'y': 74.35759259259264},
//   {'x': 14.566666666666666, 'y': 74.14759259259264},
//   {'x': 14.65, 'y': 73.93870370370375},
//   {'x': 14.733333333333333, 'y': 73.72870370370376},
//   {'x': 14.816666666666666, 'y': 73.51203703703709},
//   {'x': 14.9, 'y': 73.27703703703709},
//   {'x': 14.983333333333333, 'y': 73.0368518518519}
// ];
List<dynamic> testPastSpots= [
    
    {"x": 7.066666666666666, "y": 21.703888888888677},
    {"x": 7.15, "y": 21.52333333333312},
    {"x": 7.233333333333333, "y": 21.342777777777563},
    {"x": 7.433333333333334, "y": 21.342777777777563},
    {"x": 7.483333333333333, "y": 21.342777777777563},
    {"x": 7.566666666666666, "y": 21.162222222222006},
    {"x": 7.65, "y": 20.98166666666645},
    {"x": 7.733333333333333, "y": 20.80111111111089},
    {"x": 7.933333333333334, "y": 20.80111111111089},
    {"x": 8.016666666666667, "y": 20.620555555555335},
    {"x": 8.1, "y": 20.439999999999777},
    {"x": 8.183333333333334, "y": 20.25944444444422},
    {"x": 8.266666666666667, "y": 20.078888888888663},
    {"x": 8.433333333333334, "y": 20.078888888888663},
    {"x": 8.5, "y": 20.078888888888663},
    {"x": 8.583333333333334, "y": 19.898333333333106},
    {"x": 8.666666666666666, "y": 19.71777777777755},
    {"x": 8.75, "y": 19.537222222221992},
    {"x": 8.933333333333334, "y": 19.537222222221992},
    {"x": 8.983333333333333, "y": 19.537222222221992},
    {"x": 9.066666666666666, "y": 19.356666666666435},
    {"x": 9.15, "y": 19.176111111110878},
    {"x": 9.233333333333333, "y": 18.99555555555532},
    {"x": 9.433333333333334, "y": 18.99555555555532},
    {"x": 9.483333333333333, "y": 18.99555555555532},
    {"x": 9.566666666666666, "y": 18.814999999999763},
    {"x": 9.65, "y": 18.634444444444206},
    {"x": 9.733333333333333, "y": 18.45388888888865},
    {"x": 9.933333333333334, "y": 18.45388888888865},
    {"x": 9.983333333333333, "y": 18.45388888888865},
    {"x": 10.066666666666666, "y": 18.273333333333092},
    {"x": 10.15, "y": 18.092777777777535},
    {"x": 10.233333333333333, "y": 17.912222222221978},
    {"x": 10.433333333333334, "y": 17.912222222221978},
    {"x": 10.483333333333333, "y": 17.912222222221978},
    {"x": 10.566666666666666, "y": 17.731666666666422},
    {"x": 10.65, "y": 17.551111111110865},
    {"x": 10.733333333333333, "y": 17.370555555555308},
    {"x": 10.933333333333334, "y": 17.370555555555308},
    {"x": 10.983333333333333, "y": 17.370555555555308},
    {"x": 11.066666666666666, "y": 17.19},
    {"x": 11.15, "y": 17.009444444444443},
    {"x": 11.233333333333334, "y": 16.828888888888886},
    {"x": 11.433333333333335, "y": 16.828888888888886},
    {"x": 11.483333333333334, "y": 16.828888888888886},
    {"x": 11.566666666666666, "y": 16.64833333333333},
    {"x": 11.65, "y": 16.467777777777773},
    {"x": 11.733333333333333, "y": 16.287222222222216},
    {"x": 11.933333333333335, "y": 16.287222222222216},
    {"x": 11.983333333333334, "y": 16.287222222222216},
    {"x": 12.066666666666666, "y": 16.10666666666666},
    {"x": 12.15, "y": 15.926111111111103},
    {"x": 12.233333333333334, "y": 15.745555555555546},
    {"x": 12.433333333333335, "y": 15.745555555555546},
    {"x": 12.483333333333334, "y": 15.745555555555546},
    {"x": 12.566666666666666, "y": 15.565},
    {"x": 12.65, "y": 15.384444444444443},
    {"x": 12.733333333333335, "y": 15.203888888888886},
    {"x": 12.933333333333335, "y": 15.203888888888886},
    {"x": 12.983333333333334, "y": 15.203888888888886},
    {"x": 13.066666666666666, "y": 15.02333333333333},
    {"x": 13.15, "y": 14.842777777777773},
    {"x": 13.233333333333335, "y": 14.662222222222217},
    {"x": 13.433333333333335, "y": 14.662222222222217},
    {"x": 13.483333333333334, "y": 14.662222222222217},
    {"x": 13.566666666666666, "y": 14.48166666666666},
    {"x": 13.65, "y": 14.301111111111104},
    {"x": 13.733333333333335, "y": 14.120555555555547},
    {"x": 13.933333333333335, "y": 14.120555555555547},
    {"x": 13.983333333333334, "y": 14.120555555555547},
    {"x": 14.066666666666666, "y": 13.94},
    {"x": 14.15, "y": 13.759444444444444},
    {"x": 14.233333333333335, "y": 13.578888888888888},
    {"x": 14.433333333333335, "y": 13.578888888888888},
    {"x": 14.483333333333334, "y": 13.578888888888888},
    {"x": 14.566666666666666, "y": 13.398333333333331},
    {"x": 14.65, "y": 13.217777777777775},
    {"x": 14.733333333333335, "y": 13.037222222222218},
    {"x": 14.933333333333335, "y": 13.037222222222218},
    {"x": 14.983333333333334, "y": 13.037222222222218},

    ];

List<dynamic> testFutureSpots = [
    {"x": 15.066666666666666, "y": 12.856666666666661},
    {"x": 15.15, "y": 12.676111111111104},
    {"x": 15.233333333333335, "y": 12.495555555555547},
    {"x": 15.433333333333335, "y": 12.495555555555547},
    {"x": 15.483333333333334, "y": 12.495555555555547},
    {"x": 15.566666666666666, "y": 12.315},
    {"x": 15.65, "y": 12.134444444444444},
    {"x": 15.733333333333335, "y": 11.953888888888888},
    {"x": 15.933333333333335, "y": 11.953888888888888},
    {"x": 15.983333333333334, "y": 11.953888888888888},
    {"x": 16.066666666666666, "y": 11.773333333333331},
    {"x": 16.15, "y": 11.592777777777775},
    {"x": 16.233333333333335, "y": 11.412222222222218},
    {"x": 16.433333333333335, "y": 11.412222222222218},
    {"x": 16.483333333333334, "y": 11.412222222222218},
    {"x": 16.566666666666666, "y": 11.231666666666661},
    {"x": 16.65, "y": 11.051111111111104},
    {"x": 16.733333333333335, "y": 10.870555555555548},
    {"x": 16.933333333333335, "y": 10.870555555555548},
    {"x": 16.983333333333334, "y": 10.870555555555548},
    {"x": 17.066666666666666, "y": 10.69},
    {"x": 17.15, "y": 10.509444444444444},
    {"x": 17.233333333333335, "y": 10.328888888888889},
    {"x": 17.433333333333335, "y": 10.328888888888889},
    {"x": 17.483333333333334, "y": 10.328888888888889},
    {"x": 17.566666666666666, "y": 10.148333333333332},
    {"x": 17.65, "y": 9.967777777777776},
    {"x": 17.733333333333335, "y": 9.78722222222222},
    {"x": 17.933333333333335, "y": 9.78722222222222},
    {"x": 17.983333333333334, "y": 9.78722222222222},
    {"x": 18.066666666666666, "y": 9.606666666666664},
    {"x": 18.15, "y": 9.426111111111107},
    {"x": 18.233333333333335, "y": 9.245555555555551},
    {"x": 18.433333333333335, "y": 9.245555555555551},
    {"x": 18.483333333333334, "y": 9.245555555555551},
    {"x": 18.566666666666666, "y": 9.065},
    {"x": 18.65, "y": 8.884444444444445},
    {"x": 18.733333333333335, "y": 8.703888888888889},
    {"x": 18.933333333333335, "y": 8.703888888888889},
    {"x": 18.983333333333334, "y": 8.703888888888889},
    {"x": 19.066666666666666, "y": 8.523333333333331},
    {"x": 19.15, "y": 8.342777777777775},
    {"x": 19.233333333333335, "y": 8.16222222222222},
    {"x": 19.433333333333335, "y": 8.16222222222222},
    {"x": 19.483333333333334, "y": 8.16222222222222},
    {"x": 19.566666666666666, "y": 7.981666666666664},
    {"x": 19.65, "y": 7.801111111111108},
    {"x": 19.733333333333335, "y": 7.620555555555552},
    {"x": 19.933333333333335, "y": 7.620555555555552},
    {"x": 19.983333333333334, "y": 7.620555555555552},
];
  //fututeのyのデータを少し下げる
  List<dynamic> calcuY(List<dynamic> dataList) {
    double dif = 0.0;
    double add = 0.1;
    for (int i = 0; i < dataList.length; i++) {
      dataList[i]["y"] -= dif;
      dif += add;
    } 
    return dataList;
  }

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

      logger.d("maxdayeichipii: $maxDayHP");
      hpPercent = (currentHP / maxDayHP) * 100;
      if (currentHP < 0) {
        // currentHP = 0;
        hpPercent = 0;
      }
      if (80 < hpPercent) {
        barColor = const Color(0xFF32cd32);
        fontColor = Colors.white;
        fontPosition = 60;
      } else if (40 < hpPercent && hpPercent <= 80) {
        barColor = const Color.fromARGB(255, 0, 226, 113);
        fontColor = Colors.white;
        fontPosition = 60;
      } else if (30 < hpPercent && hpPercent <= 40) {
        barColor = const Color.fromARGB(255, 0, 226, 113);
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
    List<FlSpot> pastTmpSpots = convertHPSpotsList(testPastSpots);
    // List<FlSpot> pastTmpSpots = convertHPSpotsList(responseBody["past_spots"]);
    futureSpots = convertHPSpotsList(testFutureSpots);
    // futureSpots = convertHPSpotsList(responseBody["future_spots"]);
    // removePastSpotsData(pastTmpSpots);
    // pastSpots += pastTmpSpots;
    pastSpots = pastTmpSpots;
    logger.d(responseBody["past_spots"].runtimeType);
    logger.d("pastSpots: $pastSpots");
    logger.d("futureSpots: $futureSpots");

    updateMinMaxSpots();
    imgUrl = responseBody["url"];
    recordHighHP = responseBody["recordHighHP"].toDouble();
    recordLowHP = responseBody["recordLowHP"].toDouble();
    // activeLimitTime = responseBody["activeLimitTime"];
    activeLimitTime = "22:36";
    maxSleepDuration = responseBody["maxSleepDuration"];
    maxDayHP = responseBody["maxDayHP"].toInt();
    maxTotalDaySteps = responseBody["maxTotalDaySteps"];
    maxSleepDuration = responseBody["maxSleepDuration"];
    experienceLevel = responseBody["experienceLevel"];
    experiencePoint = responseBody["experiencePoint"];
    experiencePoint = experiencePoint % 360;
    userName = responseBody["userName"];
    avatarName = responseBody["avatarName"];
    avatarType = responseBody["avatarType"];

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
    testFutureSpots = calcuY(testFutureSpots);
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


  Future<Map> loginFirebase(isRegistered, inputEmail, inputPassword) async {
    isRegistered = true;
    logger.d("login start");
    var url = Uri.https("vignp7m26e.execute-api.ap-northeast-1.amazonaws.com",
        "/default/firebase_login_yourHP", {
      "email": inputEmail,
      "password": inputPassword,
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
