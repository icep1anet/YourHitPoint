import "dart:math";
import "package:fl_chart/fl_chart.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:fluttericon/iconic_icons.dart";
import "package:google_fonts/google_fonts.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:logger/logger.dart";

import 'package:your_hit_point/components/wave_view.dart';
import 'package:your_hit_point/utils/hex_color.dart';
import 'package:your_hit_point/utils/avatar.dart';
import 'package:your_hit_point/components/profile.dart';
import 'package:your_hit_point/components/health_level2.dart';
import "package:your_hit_point/utils/timer_func.dart";
import "package:your_hit_point/view_model/HP_notifier.dart";
import "package:your_hit_point/view_model/user_data_notifier.dart";

var logger = Logger();

class MyselfPage extends ConsumerStatefulWidget {
  // MyselfPage({Key? key}) : super(key: key);
  const MyselfPage({Key? key}) : super(key: key);
  // 使用するStateを指定
  @override
  MyselfPageState createState() => MyselfPageState();
}

// Stateを継承して使う
class MyselfPageState extends ConsumerState<MyselfPage>
    with SingleTickerProviderStateMixin {
  // AnimationController? animationController;
  // Animation<double>? animation;
  // late Tween<double> tween;
  // final Curve curve = Curves.ease;
  void initTest() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("userId");
    logger.d("deleteUserId");
  }

  //ページ起動時に呼ばれる初期化関数
  @override
  void initState() {
    super.initState();
    // animationController = AnimationController(
    //     duration: const Duration(milliseconds: 5), vsync: this);
    // tween = Tween<double>(begin: 0.0, end: 1.0);
    // tween.chain(CurveTween(curve: curve));
    // animation = animationController!.drive(tween);
    setTimerFunc(60, ref.read(hpProvider.notifier).changeHP, ref);
    // animationController!.forward();
  }

  @override
  Widget build(BuildContext context) {
    final imgUrl = ref.watch(hpProvider).imgUrl;
    // final userId = userDataProvider.userId;
    String? avatarName = ref.watch(userDataProvider).avatarName;
    // final maxDayHP = userDataProvider.maxDayHP;
    // final AnimationController animationController = AnimationController(
    //     duration: const Duration(milliseconds: 2000), vsync: this);
    return Scaffold(
        body: NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          const SliverAppBarWidget(),
        ];
      },
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(hpProvider.notifier).updateUserData(ref);
        },
        child: SingleChildScrollView(
            child: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: <Widget>[
                    hpWarning(ref.watch(hpProvider).currentHP),
                    const SizedBox(height: 30),
                    Container(
                      alignment: Alignment.center,
                      width: 200,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom:
                              BorderSide(color: Theme.of(context).focusColor),
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
                        avatarName ?? "アバター名",
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
                      currentmyAvatar(context, imgUrl, 100),
                      // _currentmyAvatar("assets/images/illust_normal.jpg"),
                      WaveViewWidget(widget: widget),
                    ]),
                    const SizedBox(height: 30),

                    // ElevatedButton(
                    //   onPressed: () {
                    //     animationController!.forward();
                    //   },
                    //   child: const Text('click here'),
                    // ),
                    MediterranesnDietView(
                      experienceLevel: ref.watch(userDataProvider).experienceLevel,
                      experiencePoint: ref.watch(userDataProvider).experiencePoint,
                    ),
                    const SizedBox(height: 30),
                    Container(
                      alignment: Alignment.center,
                      width: 200,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom:
                              BorderSide(color: Theme.of(context).focusColor),
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
                              style: GoogleFonts.roboto(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30,
                                  color: Colors.black)),
                        )),
                    const SizedBox(height: 10),
                    RecordWidget(widget: widget),
                  ],
                ))),
      ),
    ));
  }
}

class RecordWidget extends ConsumerWidget {
  const RecordWidget({
    super.key,
    required this.widget,
  });

  final MyselfPage widget;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Duration msDuration =
        Duration(milliseconds: ref.watch(userDataProvider).maxSleepDuration);
    int msHours = msDuration.inHours;
    int msMinutes = msDuration.inMinutes.remainder(60);
    return Container(
      width: 350,
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
            const SizedBox(height: 7),
            Text("最大睡眠時間",
                style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w500, fontSize: 23)),
            const SizedBox(height: 7),
            Text("最大歩数",
                style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w500, fontSize: 23)),
          ],
        ),
        const SizedBox(width: 10),
        Column(children: [
          Text(ref.watch(hpProvider).recordHighHP.round().toString(),
              style: GoogleFonts.sourceCodePro(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).hintColor)),
          // const SizedBox(height: 10),
          Text(ref.watch(hpProvider).recordLowHP.round().toString(),
              style: GoogleFonts.sourceCodePro(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).hintColor)),
          Text("${msHours}h${msMinutes}m",
              style: GoogleFonts.sourceCodePro(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).hintColor)),
          Text("${ref.watch(userDataProvider).maxTotalDaySteps}歩",
              style: GoogleFonts.sourceCodePro(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).hintColor)),
        ])
      ]),
    );
  }
}

class WaveViewWidget extends ConsumerWidget {
  const WaveViewWidget({super.key, required this.widget});

  final MyselfPage widget;
  // final int barColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
        child: WaveView(percentageValue: (ref.watch(hpProvider).currentHP / ref.watch(hpProvider).maxDayHP) * 100),
      ),
    );
  }
}

class LineChartWidget extends ConsumerWidget {
  const LineChartWidget({
    super.key,
    required this.widget,
  });

  final MyselfPage widget;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LineChart(
      LineChartData(
          minX: ref.watch(hpProvider).minGraphX,
          maxX: ref.watch(hpProvider).maxGraphX,
          minY: ref.watch(hpProvider).minGraphY,
          maxY: ref.watch(hpProvider).maxGraphY,
          backgroundColor: const Color(0xffd0e3ce),
          lineBarsData: [
            LineChartBarData(
              isCurved: true,
              color: Colors.blue,
              barWidth: 3,
              dotData: FlDotData(show: false),
              spots: ref.watch(hpProvider).pastSpots,
            ),
            LineChartBarData(
              isCurved: true,
              color: Colors.blue[400],
              barWidth: 3,
              dotData: FlDotData(show: false),
              spots: ref.watch(hpProvider).futureSpots,
              dashArray: [10, 6],
            ),
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
                  );
                },
                reservedSize: 30,
              ),
            ),
          ),
          extraLinesData: ExtraLinesData(horizontalLines: [
            HorizontalLine(
              y: 0,
              color: Colors.red,
              strokeWidth: 1,
            ),
          ])),
    );
  }

  Widget bottomGraphWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.pink,
      fontFamily: "Digital",
    );
    String text = "";

    switch (value.toInt()) {
      case 0:
        text = "00:00";
        break;
      case 2:
        text = "02:00";
        break;
      case 4:
        text = "04:00";
        break;
      case 6:
        text = "06:00";
        break;
      case 8:
        text = "08:00";
        break;
      case 10:
        text = "10:00";
        break;
      case 12:
        text = "12:00";
        break;
      case 14:
        text = "14:00";
        break;
      case 16:
        text = "16:00";
        break;
      case 18:
        text = "18:00";
        break;
      case 20:
        text = "20:00";
        break;
      case 22:
        text = "22:00";
        break;
      case 24:
        text = "00:00";
        break;
      case 26:
        text = "02:00";
        break;
      case 28:
        text = "04:00";
        break;
      case 30:
        text = "06:00";
        break;
      case 32:
        text = "08:00";
        break;
      case 34:
        text = "10:00";
        break;
      case 36:
        text = "12:00";
        break;
      case 38:
        text = "14:00";
        break;
      case 40:
        text = "16:00";
        break;

      default:
        return Container();
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(
        text,
        style: style,
      ),
    );
  }
}

class LimitTimeWidget extends ConsumerWidget {
  const LimitTimeWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text("推定活動限界",
          style: GoogleFonts.roboto(fontWeight: FontWeight.w500, fontSize: 20)),
      Text(ref.watch(hpProvider).activeLimitTime,
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

class HPWidget extends ConsumerWidget {
  const HPWidget({
    super.key,
    required this.widget,
  });

  final MyselfPage widget;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text("現在のHP",
            style: GoogleFonts.roboto(fontWeight: FontWeight.w500, fontSize: 20)
            // Theme.of(context).textTheme.headlineSmall
            ),
        Text(ref.watch(hpProvider).currentHP.toString(),
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
      expandedHeight: 300.0,
      floating: true,
      pinned: true,
      stretch: true,
      collapsedHeight: 100,
      backgroundColor: Theme.of(context).focusColor,
      toolbarHeight: 100,
      flexibleSpace: FlexibleSpaceBar(
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
      leading: IconButton(
        onPressed: () {
          // userDataProvider.initRemoveUserId();
        },
        icon: const Icon(Icons.logout),
      ),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                fullscreenDialog: true,
                builder: (context) => const ProfilePage(),
              ),
            );
          },
          // icon: utils.currentmyAvatar(context, userDataProvider.imgUrl, 20),
          icon: const Icon(Icons.settings),
          // icon: const Icon(Icons.settings_applications),
        )
      ],
    );
  }
}


Widget hpWarning(int currentHP) {
  double fontSize = 20;
  var fontstyle = GoogleFonts.bizUDGothic(
    fontWeight: FontWeight.bold,
    fontSize: fontSize,
  );
  dynamic warnignText;
  if (30 <= currentHP) {
    return Container();
  } else if (0 < currentHP && currentHP < 30) {
    warnignText = "適度に休息をとりましょう";
  } else {
    warnignText = "速やかに休息をとってください";
  }
  return Container(
      width: 320,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 242, 220, 19),
        border: Border.all(color: Colors.black, width: 5),
        // borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(10),
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("あなたのＨＰは ", style: fontstyle),
            Text(
              "$currentHP",
              style: GoogleFonts.bizUDGothic(
                fontWeight: FontWeight.bold,
                fontSize: 35,
                color: Colors.red,
              ),
            ),
            Text(" です", style: fontstyle),
          ],
        ),
        Text(warnignText, style: fontstyle),
      ]));
}