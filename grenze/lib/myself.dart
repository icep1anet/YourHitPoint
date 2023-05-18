import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';



class MyselfPage extends StatefulWidget {
  const MyselfPage({Key? key}) : super(key: key);
  // 使用するStateを指定
  @override
  State createState() => _MyselfPageState();
}

// Stateを継承して使う
class _MyselfPageState extends State<MyselfPage> {
  // データを宣言
  int count = 0;

  // データを元にWidgetを作る
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(20),
        child:Column(
          children: <Widget>[
            const SizedBox(height: 60,),
            _currentmyAvatar(null),
            const SizedBox(height: 30),
            Container(
              width: 300,
              // width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: const Color.fromARGB(255, 39, 98, 236), width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Text("現在のHP : 100", style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 10),
                  Text("推定活動限界 : 04 : 28", style: Theme.of(context).textTheme.headlineSmall),
                ],
              ),
            ),
            const SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.only(left: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text("HP推移予測", style: Theme.of(context).textTheme.headlineSmall),
              )
            ),
            const SizedBox(height: 5),
            Container(
              padding: const EdgeInsets.only(right: 20, bottom: 20),
              height: 200,
              child: LineChart(
                LineChartData(
                  backgroundColor: Colors.grey[200],
                  lineBarsData: [
                    LineChartBarData(
                      isCurved: true,
                      color: Colors.red[400],
                      barWidth: 3,
                      dotData: FlDotData(show: true),
                      spots: const [
                        FlSpot(0, 98),
                        FlSpot(1, 92),
                        FlSpot(2, 79),
                        FlSpot(3, 68),
                        FlSpot(4, 62),
                        FlSpot(5, 49),
                        FlSpot(6, 35),
                        FlSpot(7, 29),
                        FlSpot(8, 19),
                        FlSpot(9, 9),
                        FlSpot(10, 0),
                    ])
                  ],
                  titlesData: FlTitlesData(
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.only(left: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text("記録", style: Theme.of(context).textTheme.headlineSmall),
              )
            ),
            const SizedBox(height: 5),
            Container(
              width: 300,
              // width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: const Color.fromARGB(255, 39, 98, 236), width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text("就寝時残りHP", style: Theme.of(context).textTheme.headlineSmall),
                    ),
                  const SizedBox(height: 10),
                  Text("最高 : 70", style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 10),
                  Text("最低 : -30", style: Theme.of(context).textTheme.headlineSmall),
                ],
              ),
            ),
          ],
        )
      )
    );
  }


  Widget _currentmyAvatar(String? imgUrl) {
    var color = const Color(0xfffd9a6f);
    final hasImage = imgUrl != null;
    return CircleAvatar(
        backgroundColor: hasImage ? Colors.transparent : color,
        backgroundImage: hasImage ? NetworkImage(imgUrl) : null,
        radius: 120,
        child: !hasImage
            ? const Text("no image",)
            : null,
      );
  }

}
