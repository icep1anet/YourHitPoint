import "package:fl_chart/fl_chart.dart";

// データリストからFlSpotのリストを作成する関数
List<FlSpot> createHPSpotsList(List<Map> dataList) {
  return dataList.map((map) {
    double x = map["x"].toDouble();
    double y = map["y"].toDouble();
    return FlSpot(x, y);
  }).toList();
}
