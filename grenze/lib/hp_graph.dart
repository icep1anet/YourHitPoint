import "package:fl_chart/fl_chart.dart";

// データリストからFlSpotのリストを作成する関数
List<FlSpot> createHPSpotsList(List<Map> dataList) {
  return dataList.map((map) {
    double x = map["x"].toDouble();
    double y = map["y"].toDouble();
    return FlSpot(x, y);
  }).toList();
}

List<FlSpot> convertHPspotsList(List<Map> spotsList) {
  //過去、未来のデータを色々やってList<FlSpot>の形に変換してspots, futureSpotsに追加、代入
  List<Map> tmp = [];
  for (Map x in tmp) {
    tmp.add(x);
  }
  return createHPSpotsList(tmp);
}


//     List pastTmp = responseMap["past_spots"];
// // [{x: 1, y: 3}, {x: 2, y: 6}]
//     List<Map<dynamic, dynamic>> pastTmp2 = [];
//     for (Map map in pastTmp) {
//       pastTmp2.add(map);
//     }
//     List futureTmp = responseMap["future_spots"];
//     List<Map<dynamic, dynamic>> futureTmp2 = [];
//     for (Map map in futureTmp) {
//       futureTmp2.add(map);
//     }
//     List<FlSpot> pastTmp3 = createFlSpotList(pastTmp2);
//     List<FlSpot> futureTmp3 = createFlSpotList(futureTmp2);
//     logger.d("pastTmp3: $pastTmp3");
//     logger.d("pastTmp3.length: ${pastTmp3.length}");
//     logger.d("spots.length: ${spots.length}");
//     return pastTmp3, futureTmp3;