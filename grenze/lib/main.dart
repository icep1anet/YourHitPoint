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
import 'package:logger/logger.dart';

String? userId;

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
      home: const MainPage(),
      routes: {
        "/home": (context) => const MainPage(),
      },
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
    const FlSpot(0, 98),
    const FlSpot(1, 92),
    const FlSpot(2, 79),
    const FlSpot(2.6, 40),
    const FlSpot(3, 68),
    const FlSpot(4, 62),
    const FlSpot(4.3, 80),
    const FlSpot(5, 49),
    const FlSpot(6, 35),
    // FlSpot(7, 29),
    // FlSpot(8, 19),
    // FlSpot(9, 9),
    // FlSpot(10, 0),
  ];
  String? avatarName;
  String? avatarType;
  int currentHP = 0;
  String? userName;
  int? recordHighHP;
  int? recordLowHP;
  int hpNumber = 0;
  List hpList = [];
  var logger = Logger();

  @override
  void initState() {
    super.initState();
    // initTest();
    _getPrefItems();
    // _timeLog();
    // fetchFirebaseData();
    changeHP();
    Timer.periodic(const Duration(seconds: 30), (timer) {
      zeroHP();
    });
    Timer.periodic(const Duration(seconds: 1), (timer) {
      changeHP();
      // _timeLog();
      // fetchFirebaseData();
    });

    // logger.d("timer");
  }

  void zeroHP() {
    if (mounted) {
      setState(() {
        logger.d("reset!!!!!!!");
        hpNumber = 0;
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

  void initrem() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("userId");
    // for (int i = 0; i <= 10; i++) {
    //   prefs.remove("userId" + i.toString());
    // }
  }

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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageViewController.animateToPage(index,
          duration: const Duration(milliseconds: 100), curve: Curves.easeOut);
    });
  }

  Future<void> fetchFirebaseData() async {
    logger.d("startttttt");
    // var url = Uri.parse(
    //     "https://o2nr395oib.execute-api.ap-northeast-1.amazonaws.com/default/get_HP_data");
    var url =
      Uri.https("o2nr395oib.execute-api.ap-northeast-1.amazonaws.com", "/default/get_HP_data", {"userName": "a", "avatarName": "b", "avatarType": "c"});
    var response = await http.get(url);
    logger.d(response.body);
    if (response.statusCode == 200) {
      // リクエストが成功した場合、レスポンスの内容を取得して表示します
      logger.d(response.body);
  
      var responseJson = jsonDecode(response.body);
      logger.d(responseJson);
    } else {
      // リクエストが失敗した場合、エラーメッセージを表示します
      logger.d("Request failed with status: ${response.statusCode}");
    }
  }

  void changeHP() {
    if (mounted) {
      setState(() {
        currentHP = hpNumber;
        // currentHP = HPlist[HPnumber]["y"];
      });
      if (hpNumber < 14) {
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
            ),
            const FriendPage(),
          ],
          onPageChanged: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              // activeIcon: Icon(Icons.book_online),
              label: "Myself",
              tooltip: "My Page",
              backgroundColor: Color.fromARGB(255, 103, 219, 234),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people),
              // activeIcon: Icon(Icons.school_outlined),
              label: "Friends",
              tooltip: "Friends Page",
              backgroundColor: Color.fromARGB(255, 231, 154, 195),
            ),
          ],
          type: BottomNavigationBarType.shifting,
          backgroundColor: Colors.red,
          enableFeedback: true,
          selectedFontSize: 20,
          selectedIconTheme: const IconThemeData(size: 30, color: Colors.green),
          selectedItemColor: Colors.black,
          unselectedIconTheme:
              const IconThemeData(size: 25, color: Colors.white),
        ),
      );
    }
  }
}
