import "dart:math";
import "package:fl_chart/fl_chart.dart";
import "package:flutter/material.dart";
import "package:fluttericon/iconic_icons.dart";
import "package:google_fonts/google_fonts.dart";
import "main.dart";
import "wave_view.dart";
import "register.dart";
// import "package:device_info_plus/device_info_plus.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:logger/logger.dart";

class MyselfPage extends StatefulWidget {
  // MyselfPage({Key? key}) : super(key: key);
  final List<FlSpot> spots;
  final int currentHP;
  final int recordHighHP;
  final int recordLowHP;
  final Color barColor;
  final Color fontColor;
  final double fontPosition;
  const MyselfPage(
      {required this.spots,
      required this.currentHP,
      required this.recordHighHP,
      required this.recordLowHP,
      required this.barColor,
      required this.fontColor,
      required this.fontPosition,
      Key? key})
      : super(key: key);
  // 使用するStateを指定
  @override
  State createState() => _MyselfPageState();
}

// Stateを継承して使う
class _MyselfPageState extends State<MyselfPage> {
  Map test = {"x": 3, "y": 4};
  double kon = 3;
  double point = 0;
  var logger = Logger();

  // final List<FlSpot> spots;

  void initTest() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("userId");
    logger.d("delete");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   centerTitle: true,
        //   backgroundColor: const Color(0xFF0087AA),
        //   toolbarHeight: 100,
        //   title: Text(
        //     "Grenze",
        //     style: GoogleFonts.italianno(
        //         textStyle: Theme.of(context).textTheme.headlineMedium,
        //         fontSize: 70,
        //         color: Colors.white),
        //   ),
        //   actions: [
        //     IconButton(onPressed: () {}, icon: const Icon(Icons.settings))
        //   ],
        // ),
        body: NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          const SliverAppBarWidget(),
        ];
      },
      body: SingleChildScrollView(
          child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: <Widget>[
                  const SizedBox(
                    height: 30,
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
                  const SizedBox(height: 30),
                  Container(
                    alignment: Alignment.center,
                    width: 200,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Theme.of(context).focusColor),
                      ),
                    ),
                    // child: Text(
                    //   "Avatar name",
                    //   // style: GoogleFonts.orelegaOne(
                    //   style: GoogleFonts.bizUDGothic(
                    //     fontWeight: FontWeight.bold,
                    //     fontSize: 30,
                    //     color: Colors.black,
                    //   ),
                    // ),
                    child: Text(
                      "アバター名",
                      // style: GoogleFonts.orelegaOne(
                      style: GoogleFonts.bizUDGothic(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: Theme.of(context).shadowColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(children: [
                    const SizedBox(width: 20),
                    // _currentmyAvatar(null),
                    _currentmyAvatar("assets/images/illust_normal.jpg"),
                    WaveViewWidget(widget: widget),
                  ]),
                  const SizedBox(height: 30),
                  Container(
                    alignment: Alignment.center,
                    width: 200,
                    decoration: BoxDecoration(
                      //なんか合わない
                      // color: Color.fromARGB(255, 209, 209, 209),
                      border: Border(
                        bottom: BorderSide(color: Theme.of(context).focusColor
                            // Color.fromARGB(255, 24, 168, 190)
                            ),
                      ),
                    ),
                    // child: Text(
                    //   "statement",
                    //   // style: GoogleFonts.orelegaOne(
                    //   style: GoogleFonts.roboto(
                    //     fontWeight: FontWeight.bold,
                    //     fontSize: 30,
                    //     color: Colors.black,
                    //   ),
                    // ),
                    child: Text(
                      "現在の状態",
                      // style: GoogleFonts.orelegaOne(
                      style: GoogleFonts.roboto(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: Theme.of(context).shadowColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                      width: 300,
                      // width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Theme.of(context).focusColor, width: 5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.all(10),
                      child: IntrinsicWidth(
                        child: Column(children: [
                          HPWidget(widget: widget),
                          // const SizedBox(width: 20),
                          const LimitTimeWidget(),
                        ]),
                      )),
                  const SizedBox(height: 40),
                  Container(
                      width: 200,
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: Theme.of(context).focusColor))),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text("HP グラフ",
                            style: GoogleFonts.roboto(
                                fontWeight: FontWeight.bold, fontSize: 30)),
                      )),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.only(right: 20),
                    height: 200,
                    child: LineChartWidget(widget: widget),
                  ),
                  const SizedBox(height: 10),
                  Container(
                      width: 200,
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: Theme.of(context).focusColor,
                                  width: 1.5))),
                      child: Align(
                        alignment: Alignment.center,
                        // child: Text("HP record",
                        //     // style: GoogleFonts.orelegaOne(
                        //     style: GoogleFonts.roboto(
                        //         fontWeight: FontWeight.bold,
                        //         fontSize: 30,
                        //         color: Colors.black)),
                        child: Text("HP 記録",
                            // style: GoogleFonts.orelegaOne(
                            style: GoogleFonts.roboto(
                                fontWeight: FontWeight.bold,
                                fontSize: 30,
                                color: Colors.black)),
                      )),
                  const SizedBox(height: 10),
                  RecordWidget(widget: widget)
                ],
              ))),
    ));
  }

  Widget _currentmyAvatar(String? imgUrl) {
    var color = const Color(0xffd9d9d9);
    final hasImage = imgUrl != null;
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(width: 5, color: Theme.of(context).focusColor),
      ),
      child: CircleAvatar(
        backgroundColor: hasImage ? Colors.transparent : color,
        backgroundImage: hasImage ? AssetImage(imgUrl) : null,
        radius: 100,
        child: !hasImage
            ? Text("Avatar image",
                // style: GoogleFonts.orelegaOne(
                style: GoogleFonts.roboto(
                  color: const Color(0xff1e90ff),
                  fontWeight: FontWeight.bold,
                  fontSize: 26,
                ))
            : null,
      ),
    );
  }
}

class RecordWidget extends StatelessWidget {
  const RecordWidget({
    super.key,
    required this.widget,
  });

  final MyselfPage widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      // width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).focusColor, width: 5),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(10),
      child: Row(children: [
        const SizedBox(
          //english
          width: 10,
          //日本語
          // width: 30,
        ),
        Column(
          children: [
            Text("過去最高 HP",
                style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w500, fontSize: 23)),
            const SizedBox(height: 7),
            Text("過去最低 HP",
                style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w500, fontSize: 23)),
          ],
        ),
        const SizedBox(width: 30),
        Column(children: [
          Text(widget.recordHighHP.toString(),
              style: GoogleFonts.sourceCodePro(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).hintColor)),
          // const SizedBox(height: 10),
          Text(widget.recordLowHP.toString(),
              style: GoogleFonts.sourceCodePro(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).hintColor)),
        ])
      ]),
    );
  }
}

class WaveViewWidget extends StatelessWidget {
  const WaveViewWidget({
    super.key,
    required this.widget,
    // required this.barColor
  });

  final MyselfPage widget;
  // final int barColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 8, top: 16),
      child: Container(
        width: 60,
        height: 160,
        decoration: BoxDecoration(
          //ここがhpの上部分
          color: HexColor("#E8EDFE"),
          // color: HexColor("#0087aa"),
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(80.0),
              bottomLeft: Radius.circular(80.0),
              bottomRight: Radius.circular(80.0),
              topRight: Radius.circular(80.0)),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: const Color(0xFF3A5160).withOpacity(0.4),
                offset: const Offset(2, 2),
                blurRadius: 4),
          ],
        ),
        child: WaveView(
          percentageValue: widget.currentHP.toDouble(),
          //black
          // fontcolor: Theme.of(context).shadowColor,
          //white
          fontcolor: widget.fontColor,
          //red
          // fontcolor: Theme.of(context).shadowColor,
          barcolor: widget.barColor,
          //真ん中
          // fontposition: 0,
          //中央下
          fontposition: widget.fontPosition,
          // fontposition: 48.5,
        ),
      ),
    );
  }
}

class LineChartWidget extends StatelessWidget {
  const LineChartWidget({
    super.key,
    required this.widget,
  });

  final MyselfPage widget;
  final List<FlSpot> spots = const [
    //   FlSpot(0, 98),
    //   FlSpot(1, 92),
    //   FlSpot(2, 79),
    //   FlSpot(2.6, 40),
    //   FlSpot(3, 68),
    //   FlSpot(4, 62),
    FlSpot(4.3, 80),
    FlSpot(5, 49),
    FlSpot(6, 35),
    FlSpot(7, 29),
    FlSpot(8, 19),
    FlSpot(9, 9),
    FlSpot(10, 0),
  ];

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        minX: 0,
        maxX: 6,
        backgroundColor: const Color(0xffd0e3ce),
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
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              getTitlesWidget: (value, meta) {
                return bottomGraphWidgets(
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
    );
  }

  Widget bottomGraphWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.pink,
      fontFamily: "Digital",
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

    // text = value.toInt().toString();
    switch (value.toInt()) {
      case 0:
        text = "00:00";
        break;
      case 4:
        text = "04:00";
        break;
      case 8:
        text = "08:00";
        break;
      case 12:
        text = "12:00";
        break;
      case 16:
        text = "16:00";
        break;
      case 20:
        text = "20:00";
        break;
      case 24:
        text = "00:00";
        break;
      case 28:
        text = "04:00";
        break;
      case 32:
        text = "08:00";
        break;
      case 36:
        text = "12:00";
        break;
      case 40:
        text = "16:00";
        break;
      case 44:
        text = "20:00";
        break;
      case 48:
        text = "00:00";
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

class LimitTimeWidget extends StatelessWidget {
  const LimitTimeWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text("推定活動限界",
          style: GoogleFonts.roboto(fontWeight: FontWeight.w500, fontSize: 20)),
      Text("23:43",
          style: GoogleFonts.sourceCodePro(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).hintColor)),
      const Icon(
        Iconic.moon_inv,
        size: 15,
      )
    ]);
  }
}

class HPWidget extends StatelessWidget {
  const HPWidget({
    super.key,
    required this.widget,
  });

  final MyselfPage widget;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text("現在のHP",
            style: GoogleFonts.roboto(fontWeight: FontWeight.w500, fontSize: 20)
            // Theme.of(context).textTheme.headlineSmall
            ),
        Text(widget.currentHP.toString(),
            style: GoogleFonts.sourceCodePro(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).hintColor)),
        Transform.rotate(
            angle: 270 * pi / 180,
            child: const Icon(
              Icons.battery_4_bar,
              size: 20,
            )),
      ],
    );
  }
}

class SliverAppBarWidget extends StatelessWidget {
  const SliverAppBarWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      // automaticallyImplyLeading: false,
      expandedHeight: 300.0,
      floating: true,
      pinned: true,
      stretch: true,
      // primary: false,
      collapsedHeight: 100,
      backgroundColor: Theme.of(context).focusColor,
      // const Color(0xff00a5bf),
      toolbarHeight: 100,
      flexibleSpace: FlexibleSpaceBar(
          // stretchModes: []
          centerTitle: true,
          collapseMode: CollapseMode.parallax,
          title: Text("My Hit Point",
              style: GoogleFonts.bebasNeue(
                  textStyle: Theme.of(context).textTheme.headlineMedium,
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).cardColor)),
          background: Image.asset(
            "assets/images/heartshock2.jpg",
            fit: BoxFit.cover,
          )),
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
            icon: const Icon(Icons.settings_applications))
      ],
    );
  }
}
