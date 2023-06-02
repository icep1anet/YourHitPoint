import "package:flutter/material.dart";
import "package:fl_chart/fl_chart.dart";
import "register.dart";
import "package:device_info_plus/device_info_plus.dart";
import "main.dart";


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
  List<FlSpot> spots = const [
    FlSpot(0, 98),
    FlSpot(1, 92),
    FlSpot(2, 79),
    FlSpot(2.6, 40),
    FlSpot(3, 68),
    FlSpot(4, 62),
    FlSpot(4.3, 80),
    FlSpot(5, 49),
    FlSpot(6, 35),
    // FlSpot(7, 29),
    // FlSpot(8, 19),
    // FlSpot(9, 9),
    // FlSpot(10, 0),
  ];
  // DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  // Future testt() async{
  //     final info = await deviceInfo.deviceInfo;
  //     print(info.data);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Myself"),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    fullscreenDialog: true,
                    builder: (context) => const RegisterPage(),
                  ),
                );
              }, 
              icon: const Icon(Icons.settings)
            ),
            IconButton(
              onPressed: () {
                // testt();
              }, 
              icon: const Icon(Icons.add)
            ),
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
                  if (userId != null) Text(userId!),
                  // TextButton(
                  //   onPressed: () {
                  //     setState(() {
                  //       spots.add(FlSpot(point, 10*point));
                  //       point++;
                  //     });
                  //   },
                  //   child: const Text("押せるよ"),
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
                  Container(
                    padding: const EdgeInsets.only(right: 20, bottom: 20),
                    height: 200,
                    child: LineChart(
                      LineChartData(
                        minX: 0,
                        maxX: 6,
                        backgroundColor: Colors.grey[200],
                        lineBarsData: [
                          LineChartBarData(
                            isCurved: true,
                            color: Colors.red[400],
                            barWidth: 3,
                            dotData: FlDotData(show: true),
                            spots: spots,
                            dashArray: [10, 6],
                          )
                        ],
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
      fontFamily: "Digital",
    );
    String text;
    switch (value.toInt()) {
      case 0:
        text = "00:00";
        break;
      case 1:
        text = "04:00";
        break;
      case 2:
        text = "08:00";
        break;
      case 3:
        text = "12:00";
        break;
      case 4:
        text = "16:00";
        break;
      case 5:
        text = "20:00";
        break;
      case 6:
        text = "23:59";
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
