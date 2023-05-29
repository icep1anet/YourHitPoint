import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:fluttericon/iconic_icons.dart';
import 'package:google_fonts/google_fonts.dart';
// import "package:fluttericon/font_awesome5_icons.dart";

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
            SliverAppBar(

              // automaticallyImplyLeading: false,
              expandedHeight: 300.0,
              floating: true,
              pinned: true,
              stretch: true,
              // primary: false,
              collapsedHeight: 100,
              backgroundColor: const Color(0xFF0087AA),
              toolbarHeight: 100,
              flexibleSpace: FlexibleSpaceBar(
                  // stretchModes: []
                  centerTitle: true,
                  collapseMode: CollapseMode.parallax,
                  title: Text("Hit Point",
                  style: GoogleFonts.bebasNeue(
                  textStyle: Theme.of(context).textTheme.headlineMedium,
                  fontSize: 50,
                  color: Colors.white)),
                  background: Image.network(
                    // "https://images.pexels.com/photos/417173/pexels-photo-417173.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260",
                    "https://www.sozailab.jp/db_img/sozai/15984/e6f2dcb31db39a2a7ad9f1622696c84e.png",
                    fit: BoxFit.cover,
                  )),
                   actions: [
                    IconButton(onPressed: () {}, icon: const Icon(Icons.settings_applications))
                  ],
            ),
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
                  Container(
                    alignment: Alignment.center,
                    width: 250,

                    decoration: const BoxDecoration(
                      
                    border: Border(
                      bottom: BorderSide(
                      color: Color(0xFF0087AA)),
                      ),
                    ),
                    child: Text("Avatar name",
                    style: GoogleFonts.orelegaOne(
                      fontSize: 30,
                      color: Colors.black,
                      
                    ),),

                  ),
                  const SizedBox(height: 30),

                  _currentmyAvatar(null),
                  const SizedBox(height: 30),

                  Container(
                    
                    alignment: Alignment.center,
                    width: 250,

                    decoration: const BoxDecoration(
                      //なんか合わない
                      // color: Color.fromARGB(255, 209, 209, 209),
                      
                    border: Border(
                      bottom: BorderSide(
                      color: Color(0xFF0087AA)),
                      ),
                    ),
                    child: Text("statement",
                    style: GoogleFonts.orelegaOne(
                      fontSize: 30,
                      color: Colors.black,
                      
                    ),),),

                  const SizedBox(height: 20),

                  Container(
                    width: 300,
                    // width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: const Color(0xff0087aa),
                          width: 5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        const SizedBox(width: 10),
                        Column(
                          children: [
                            Text("現在のHP",
                                style: GoogleFonts.zenAntiqueSoft(
                                  fontSize: 20
                                )
                                // Theme.of(context).textTheme.headlineSmall
                                ),
                            const SizedBox(height: 10),
                            Text("推定活動限界",
                                style: GoogleFonts.zenAntiqueSoft(
                                  fontSize: 20
                                )),
                          ],
                        ),
                        const SizedBox(width: 30),
                          Column(
                            children: [
                              Text("94",
                                style: GoogleFonts.orelegaOne(
                                  fontSize: 25,
                                  color: Colors.red
                                )
                                // Theme.of(context).textTheme.headlineSmall
                                ),
                            const SizedBox(height: 10),

                            Text("23:43",
                                style: GoogleFonts.orelegaOne(
                                  fontSize: 25,
                                  color: Colors.red
                                )),
                            ]
                          ),
                          const SizedBox(width: 20,),
                          Column(
                            children: [
                              Transform.rotate(angle: 270 * pi / 180,
                              child: const Icon(Icons.battery_4_bar)
                              ),
                              const SizedBox(height: 10),
                              const Icon(Iconic.moon_inv)
                            ],
                          ),
                          // addAllListData(),

                        ]

                    )
                  ),
                  const SizedBox(height: 40),
                  Container(
                      width: 300,
                      padding: const EdgeInsets.all(5),

                      
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Color(0xff0087aa)
                          )
                        )
                      ),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text("HP graph",
                            style: GoogleFonts.orelegaOne(
                              fontSize: 25
                            )),
                      )),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.only(right: 20),
                    height: 200,
                    //微妙
                    // decoration: const BoxDecoration(
                    //   border: Border(
                    //     bottom: BorderSide(
                    //       color: Color(0xff0087aa)
                    //     )
                    //   )
                    // ),
                    child: LineChart(
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
                      padding: const EdgeInsets.all(10),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text("HP record",
                            style: GoogleFonts.orelegaOne(
                              fontSize: 30,
                              color: Colors.black
                            )),
                      )),
                  const SizedBox(height: 5),
                  Container(
                    width: 300,
                    // width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: const Color(0xff0087aa),
                          width: 5
                          ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                    Column(
                      children: [
                        // const Align(
                        //   alignment: Alignment.center,
                        //   // child: Text("就寝時残りHP",
                        //   //     style: Theme.of(context).textTheme.headlineSmall),
                        // ),
                        // const SizedBox(height: 10),
                        Text("highesst HP",
                            style: GoogleFonts.orelegaOne(
                              fontSize: 30
                            )),
                        const SizedBox(height: 10),
                        Text("lowest HP",
                            style: GoogleFonts.orelegaOne(
                              fontSize: 30
                            )),
                      ],
                    ),

                    const SizedBox(width: 50),

                    Column(
                      children: [
                      Text("110",
                            style: GoogleFonts.orelegaOne(
                              fontSize: 30,
                              color: Colors.red
                            )),
                        const SizedBox(height: 10),
                        Text("-10",
                            style: GoogleFonts.orelegaOne(
                              fontSize: 30,
                              color: Colors.red
                            )),
                      ]
                    )
                    ]
                  ),
              )],
              )
              )),
        ));
  }

  Widget _currentmyAvatar(String? imgUrl) {
    var color = const Color(0xffd9d9d9);
    final hasImage = imgUrl != null;
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          width: 5,
          color: const Color(0xff0087aa)),
      ),
      child: CircleAvatar(
        
        backgroundColor: hasImage ? Colors.transparent : color,
        backgroundImage: hasImage ? NetworkImage(imgUrl) : null,
        radius: 120,
        
        child: !hasImage
            ?  Text(
                "Avatar image",
                style: GoogleFonts.orelegaOne(
                  fontSize: 26,
                )
              )
            : null,
      ),
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.pink,
      fontFamily: 'Digital',
    );
    String text;
    switch (value.toInt()) {
      case 0:
        text = '00:00';
        break;
      case 1:
        text = '04:00';
        break;
      case 2:
        text = '08:00';
        break;
      case 3:
        text = '12:00';
        break;
      case 4:
        text = '16:00';
        break;
      case 5:
        text = '20:00';
        break;
      case 6:
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
