import "dart:convert";
import "package:flutter/material.dart";
import "myself.dart";
import "register.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:flutter/services.dart";
import "dart:async";
import "package:fl_chart/fl_chart.dart";
import "package:http/http.dart" as http;
import "friend.dart";
import "package:logger/logger.dart";
import "package:salomon_bottom_bar/salomon_bottom_bar.dart";
import "package:google_fonts/google_fonts.dart";
import 'package:flutter_localizations/flutter_localizations.dart';

String? userId;
const locale = Locale("ja", "JP");

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: const Color(0xffdc143c),
        hintColor: Colors.red,
        focusColor: const Color(0xff00a5bf),
        cardColor: Colors.white,
        shadowColor: Colors.black,
        canvasColor: const Color(0xffd0e3ce),
        hoverColor: const Color(0xFF32cd32),
        splashColor: const Color(0xff00ff7f),
        dividerColor: const Color(0xffffd700),
      ),
      home: const MainPage(),
      //画面遷移するときのルート追加
      routes: {
        "/home": (context) => const MainPage(),
      },
      locale: locale,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        locale,
      ],
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final _pageViewController = PageController();
  int _selectedIndex = 0;
  // String? userId;
  // dynamic _now, _year, _month, _day, _hour, _minute, _second;
  List<FlSpot> spots = [
    // const FlSpot(0, 98),
    // const FlSpot(1, 92),
    // const FlSpot(2, 79),
    // const FlSpot(2.6, 40),
    // const FlSpot(3, 68),
    // const FlSpot(4, 62),
    // const FlSpot(4.3, 80),
    // const FlSpot(5, 49),
    // const FlSpot(6, 35),
    // FlSpot(7, 29),
    // FlSpot(8, 19),
    // FlSpot(9, 9),
    // const FlSpot(10, 0),
    // const FlSpot(23.3, 10),
  ];
  String? avatarName;
  String? avatarType;
  int currentHP = 100;
  String? userName;
  double recordHighHP = 0;
  double recordLowHP = 0;
  int hpNumber = 0;
  List hpList = [];
  var logger = Logger();
  List<Map> dataList = [
    {"x": 1.0, "y": 2.0},
    {"x": 3.0, "y": 4.0},
    {"x": 5.0, "y": 6.0},
  ];
  String? imgUrl;
  Color barColor = const Color(0xFF32cd32);
  Color fontColor = Colors.white;
  double fontPosition = 60;
  DateTime? latestDataTime;

  //ページ起動時に呼ばれる初期化関数
  @override
  void initState() {
    super.initState();
    logger.d(spots);
    // initTest();
    _getPrefItems();
    // _timeLog();
    fetchFirebaseData();
    changeHP();
    Timer.periodic(const Duration(seconds: 1000), (timer) {
      zeroHP();
    });
    Timer.periodic(const Duration(seconds: 10), (timer) {
      changeHP();
      // _timeLog();
      // fetchFirebaseData();
    });
    spots = createFlSpotList(dataList);
    // logger.d("timer");
  }

  // データリストからFlSpotのリストを作成する関数
  List<FlSpot> createFlSpotList(List<Map> dataList) {
    return dataList.map((map) {
      double x = map["x"];
      double y = map["y"];
      return FlSpot(x, y);
    }).toList();
  }

  //debug
  void zeroHP() {
    if (mounted) {
      setState(() {
        logger.d("reset!!!!!!!");
        hpNumber = 120;
      });
    }
  }

  // void _timeLog() {
  //   if (mounted) {
  //     setState(() {
  //       _now = DateTime.now();
  //       _year = _now.year;
  //       _month = _now.month;
  //       _day = _now.day;
  //       _hour = _now.hour;
  //       _minute = _now.minute;
  //       _second = _now.second;
  //     });
  //     logger.d(_now);
  //     logger.d("$_year年$_month月$_day日 $_hour時$_minute分$_second秒");
  //   }
  // }

  //debug
  void initrem() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("userId");
    // for (int i = 0; i <= 10; i++) {
    //   prefs.remove("userId" + i.toString());
    // }
  }

  //registerページに画面遷移
  void moveToRegister() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => const RegisterPage(),
      ),
    );
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // setState(() {
    //   userId = prefs.getString("userId");
    // });
  }

  //ローカルdbからuserIdを取ってくる&debug
  void _getPrefItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString("userId");
    });
    String? userName = prefs.getString("userName");
    // String? avatarName = prefs.getString("avatarName");
    // String? avatarType = prefs.getString("avatarType");
    if (userName != null) logger.d("userName:$userName");
  }

  //ページ移動系
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageViewController.animateToPage(index,
          duration: const Duration(milliseconds: 100), curve: Curves.easeOut);
    });
  }

  // //responseを送ってfirebaseにデータ登録する
  Future<void> fetchFirebaseData() async {
    logger.d("startttttt");
    DateTime now = DateTime.now();
    DateTime hoursAgo = now.add(const Duration(hours: 4) * -1);
    if (latestDataTime != null) {
      if (latestDataTime!.compareTo(hoursAgo) == 1) {
        hoursAgo = latestDataTime!;
        logger.d("latestDataTime:$latestDataTime");
      }
    }
    var url = Uri.https("o2nr395oib.execute-api.ap-northeast-1.amazonaws.com",
        "/default/get_HP_data", {
      "userId": "id_abcd",
      "startTimestamp": hoursAgo.toString(),
      "endTimestamp": now.toString()
    });
    var response = await http.get(url);
    logger.d(response.body);
    if (response.statusCode == 200) {
      // リクエストが成功した場合、レスポンスの内容を取得して表示します
      logger.d("成功しました！");
      logger.d(response.body);

      var responseMap = jsonDecode(response.body);
      logger.d("past:");
      logger.d(responseMap["past_spots"]);
      List tes1 = responseMap["past_spots"];
      List<Map<dynamic, dynamic>> tes2 = [];
      for (Map a in tes1) {
        tes2.add(a);
      }
      logger.d("daiichidannkai");
      List<FlSpot> tes = createFlSpotList(tes2);
      logger.d(tes);
      logger.d("tes.length: ${tes.length}");
      logger.d("spots.length: ${spots.length}");
      if (spots.isNotEmpty) {
        logger.d("spots is not Empty");
        spots.removeRange(0, tes.length - 1);
      }
      // for (int i = 0; i < tes.length; i++) {
      //   spots.add(tes[i]);
      // }
      setState(() {
        // spots = tes;
        // spots.addAll(tes);
        imgUrl = responseMap["url"];
        spots = spots + tes;
        recordHighHP = responseMap["recordHighHP"];
        recordLowHP = responseMap["recordLowHP"];
      });
      logger.d("spotsAfter: $spots");
      logger.d("spotsLengthAfter: ${spots.length}");
      //latestDataTimeの更新
      latestDataTime = now;
    } else {
      // リクエストが失敗した場合、エラーメッセージを表示します
      logger.d("Request failed with status: ${response.statusCode}");
    }
  }

  //現在のHPを変える
  void changeHP() {
    if (mounted) {
      if (hpNumber < 14) {
        setState(() {
          // currentHP = hpNumber;
          // currentHP = hpList[hpNumber]["y"];
        });
        if (80 < currentHP) {
          barColor = const Color(0xFF32cd32);
          fontColor = Colors.white;
          fontPosition = 60;
        } else if (40 < currentHP && currentHP <= 80) {
          barColor = const Color(0xff00ff7f);
          fontColor = Colors.white;
          fontPosition = 60;
        } else if (30 < currentHP && currentHP <= 40) {
          barColor = const Color(0xff00ff7f);
          fontColor = Colors.black;
          fontPosition = 0;
        } else if (0 < currentHP && currentHP <= 30) {
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
    }
  }

  @override
  Widget build(BuildContext context) {
    if (userId == null) {
      // logger.d("null");
      return Scaffold(
          appBar: AppBar(
            //オーバーレイが明るいカラースキームになります。
            systemOverlayStyle: SystemUiOverlayStyle.light,
            title: const Text("Register"),
            centerTitle: true,
          ),
          body: Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(
              bottom: 200,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Not registered"),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        fullscreenDialog: true,
                        builder: (context) => const RegisterPage(),
                      ),
                    );
                  },
                  child: const Text("Register"),
                ),
              ],
            ),
          ));
    } else {
      return Scaffold(
        body: PageView(
          controller: _pageViewController,
          children: <Widget>[
            MyselfPage(
              spots: spots,
              currentHP: currentHP,
              recordHighHP: recordHighHP,
              recordLowHP: recordLowHP,
              barColor: barColor,
              fontColor: fontColor,
              fontPosition: fontPosition,
              imgUrl: imgUrl,
            ),
            const FriendPage(),
          ],
          onPageChanged: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
        bottomNavigationBar: SalomonBottomBar(
            backgroundColor: const Color.fromARGB(255, 178, 211, 244),
            currentIndex: _selectedIndex,
            selectedItemColor: const Color(0xff6200ee),
            unselectedItemColor: const Color(0xff757575),
            onTap: _onItemTapped,
            //(index) {
            //   setState(() {
            //     _selectedIndex = index;
            //   });
            // },
            items: _navBarItems),
        // bottomNavigationBar: BottomNavigationBar(
        //   currentIndex: _selectedIndex,
        //   onTap: _onItemTapped,
        //   items: const <BottomNavigationBarItem>[
        //     BottomNavigationBarItem(
        //       icon: Icon(Icons.person),
        //       // activeIcon: Icon(Icons.book_online),
        //       label: "Myself",
        //       tooltip: "My Page",
        //       backgroundColor: Color.fromARGB(255, 103, 219, 234),
        //     ),
        //     BottomNavigationBarItem(
        //       icon: Icon(Icons.people),
        //       // activeIcon: Icon(Icons.school_outlined),
        //       label: "Friends",
        //       tooltip: "Friends Page",
        //       backgroundColor: Color.fromARGB(255, 231, 154, 195),
        //     ),
        //   ],
        //   type: BottomNavigationBarType.shifting,
        //   backgroundColor: Colors.red,
        //   enableFeedback: true,
        //   selectedFontSize: 20,
        //   selectedIconTheme: const IconThemeData(size: 30, color: Colors.green),
        //   selectedItemColor: Colors.black,
        //   unselectedIconTheme:
        //       const IconThemeData(size: 25, color: Colors.white),
        // ),
      );
    }
  }
}

final _navBarItems = [
  SalomonBottomBarItem(
    icon: const Icon(Icons.person),
    title: Text(
      "Myself",
      //iconが真ん中startなのでできない
      // textAlign: TextAlign.left,
      style: GoogleFonts.orelegaOne(fontSize: 20),
    ),
    selectedColor: const Color.fromARGB(255, 2, 179, 8),
  ),
  SalomonBottomBarItem(
      icon: const Icon(Icons.people),
      title: Text("Friends", style: GoogleFonts.orelegaOne(fontSize: 20)),
      selectedColor: Colors.pink)
];

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    return int.parse(hexColor, radix: 16);
  }
}

        // onTap: _onItemTapped,
        // selectedLabelStyle: GoogleFonts.orelegaOne(
        //   fontSize: 25
        // ),
        // items: const <BottomNavigationBarItem>[
        //   BottomNavigationBarItem(
        //     icon: Icon(Icons.person),
        //     // activeIcon: Icon(Icons.book_online),
        //     label: "Myself",

        //     tooltip: "My Page",
        //     backgroundColor: Color.fromARGB(255, 179, 206, 233),
        //   ),
        //   BottomNavigationBarItem(
        //     icon: Icon(Icons.people),
        //     // activeIcon: Icon(Icons.school_outlined),
        //     label: "Friends",
        //     tooltip: "Friends Page",
        //     backgroundColor: Color.fromARGB(255, 231, 154, 195),
        //   ),
        // ],
        // type: BottomNavigationBarType.shifting,
        // backgroundColor: Colors.red,
        // enableFeedback: true,
        // selectedFontSize: 20,
        // // selectedIconTheme: const IconThemeData(size: 30, color: Color.fromARGB(255, 3, 146, 34)),
        // selectedItemColor: Colors.black,
        // unselectedIconTheme: const IconThemeData(size: 25, color: Colors.white),
 