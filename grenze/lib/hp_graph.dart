import "package:fl_chart/fl_chart.dart";
import "package:logger/logger.dart";

var logger = Logger();

// データリストからFlSpotのリストを作成する関数
List<FlSpot> createHPSpotsList(List<Map> dataList) {
  return dataList.map((map) {
    double x = map["x"].toDouble();
    double y = map["y"].toDouble();
    return FlSpot(x, y);
  }).toList();
}

List<FlSpot> convertHPSpotsList(List<dynamic> spotsList) {
  //過去、未来のデータを色々やってList<FlSpot>の形に変換してspots, futureSpotsに追加、代入
  List<Map> tmp = [];
  for (Map x in spotsList) {
    tmp.add(x);
  }
  return createHPSpotsList(tmp);
}
