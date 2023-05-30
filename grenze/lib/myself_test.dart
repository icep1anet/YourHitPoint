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
  Map test = {"x": 3, "y": 4};
  double kon = 3;
  double point = 0;
  List<FlSpot> spots1 = const [
    // FlSpot(0.5, 98),
    // FlSpot(1, 92),
    // FlSpot(2.1, 79),
    // FlSpot(2.6, 40),
    // FlSpot(3, 68),
    FlSpot(4, 62),
    FlSpot(4.3, 80),
    FlSpot(5, 49),
    FlSpot(6, 35),
    // FlSpot(0, 98),
    
    // FlSpot(7, 29),
    // FlSpot(8, 19),
    // FlSpot(9, 9),
    // FlSpot(10, 0),
  ];
  List<FlSpot> spots2 = const [
    // FlSpot(0, 98),
    // FlSpot(1, 92),
    // FlSpot(2, 79),
    // FlSpot(2.6, 40),
    FlSpot(3, 68),
    FlSpot(4, 62),
    FlSpot(4.3, 61),
    FlSpot(5, 59),
    FlSpot(6, 55),
    FlSpot(7, 52),
    FlSpot(23, 45),
    // FlSpot(24, 40),
    // FlSpot(24.4, 35),
    // FlSpot(25.2, 32),
    // FlSpot(28.2, 27),

    FlSpot(2, 45),
    FlSpot(8, 19),
    FlSpot(9, 9),
    FlSpot(10, 0),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Myself"),
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.settings))
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: <Widget>[
                  const SizedBox(
                    height: 60,
                  ),
                  // TextButton(
                  //   onPressed: () {
                  //     setState(() {
                  //       spots.add(FlSpot(point, 10*point));
                  //       point++;
                  //     });
                  //   },
                  //   child: const Text('押せるよ'),
                  // ),
                  _currentmyAvatar(null),
                  const SizedBox(height: 30),
                  Container(
                    width: 300,
                    // width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: const Color.fromARGB(255, 39, 98, 236),
                          width: 2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Text("現在のHP : 100",
                            style: Theme.of(context).textTheme.headlineSmall),
                        const SizedBox(height: 10),
                        Text("推定活動限界 : 04 : 28",
                            style: Theme.of(context).textTheme.headlineSmall),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  Container(
                      padding: const EdgeInsets.only(left: 20),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text("HP推移予測",
                            style: Theme.of(context).textTheme.headlineSmall),
                      )),
                  const SizedBox(height: 5),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                      padding: const EdgeInsets.only(right: 20, bottom: 20, top: 50),
                      height: 200,
                      width: 500,
                      child: LineChart(
                        LineChartData(
                          // minX: 0,
                          // maxX: 6,
                          backgroundColor: Colors.grey[200],
                          lineBarsData: [
                            LineChartBarData(
                              isCurved: true,
                              color: Colors.red[400],
                              barWidth: 3,
                              dotData: FlDotData(show: true),
                              spots: spots1,
                            ),
                            LineChartBarData(
                              isCurved: true,
                              color: Colors.blue[400],
                              barWidth: 3,
                              dotData: FlDotData(show: true),
                              spots: spots2,
                              dashArray: [7, 1],
                            ),
                          ],
                          extraLinesData: ExtraLinesData(
                            horizontalLines: [
                              HorizontalLine(
                                y: 0,
                                color: Colors.green,
                                // strokeWidth: 3,
                                // dashArray: [20, 10],
                              ),
                            ],
                          ),
                          titlesData: FlTitlesData(
                            rightTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false)),
                            topTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false)),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                interval: 1,
                                getTitlesWidget: (value, meta) {
                                  return bottomTitleWidgets(
                                    value,
                                    meta,
                                    // constraints.maxWidth,
                                  );
                                },
                                reservedSize: 30,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                      padding: const EdgeInsets.only(left: 20),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text("記録",
                            style: Theme.of(context).textTheme.headlineSmall),
                      )),
                  const SizedBox(height: 5),
                  Container(
                    width: 300,
                    // width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: const Color.fromARGB(255, 39, 98, 236),
                          width: 2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text("就寝時残りHP",
                              style: Theme.of(context).textTheme.headlineSmall),
                        ),
                        const SizedBox(height: 10),
                        Text("最高 : 70",
                            style: Theme.of(context).textTheme.headlineSmall),
                        const SizedBox(height: 10),
                        Text("最低 : -30",
                            style: Theme.of(context).textTheme.headlineSmall),
                      ],
                    ),
                  ),
                ],
              )),
        ));
  }

  Widget _currentmyAvatar(String? imgUrl) {
    var color = const Color(0xfffd9a6f);
    final hasImage = imgUrl != null;
    return CircleAvatar(
      backgroundColor: hasImage ? Colors.transparent : color,
      backgroundImage: hasImage ? NetworkImage(imgUrl) : null,
      radius: 120,
      child: !hasImage
          ? const Text(
              "no image",
            )
          : null,
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.pink,
      fontFamily: 'Digital',
    );
    String text = "";
    // int test = value.toInt();
    // int check = 0;
    // for (int i = 0; i<12; i++) {
    //   if (test == check) {
    //     text = test.toString() + ":00";
    //     break;
    //   } else {
    //     if (check == 24) {
    //       check == 0;
    //     }
    //     check += 4;
    //   }
    // }

    // if (text == "") {
    //   return Container();
    // }
    
    text = value.toInt().toString();
    switch (value.toInt().toString()) {
      case "0":
        text = '00:00';
        break;
      case "4":
        text = '04:00';
        break;
      case "8":
        text = '08:00';
        break;
      case "12":
        text = '12:00';
        break;
      case "16":
        text = '16:00';
        break;
      case "20":
        text = '20:00';
        break;
      case "24":
        text = '23:59';
        break;



      default:
        return Container();
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(text, style: style),
    );
  }
}
