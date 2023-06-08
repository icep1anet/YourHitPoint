import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import "myself.dart";
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
// import "design.dart";
// import "asset_manifest.dart";
import 'package:fl_chart/fl_chart.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;
import "dart:convert";

void main() {
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
    const FlSpot(10, 0),
    const FlSpot(23.3, 10),
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
    var url = Uri.https(
        "o2nr395oib.execute-api.ap-northeast-1.amazonaws.com",
        "/default/get_HP_data",
        {"userName": "a", "avatarName": "b", "avatarType": "c"});
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

  //現在のHPを変える
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
    return Scaffold(
      body: PageView(
        controller: _pageViewController,
        children: const <Widget>[
          MyselfPage(),
          Text("b"),
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
    );
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
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor';
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
        //     label: 'Myself',

        //     tooltip: "My Page",
        //     backgroundColor: Color.fromARGB(255, 179, 206, 233),
        //   ),
        //   BottomNavigationBarItem(
        //     icon: Icon(Icons.people),
        //     // activeIcon: Icon(Icons.school_outlined),
        //     label: 'Friends',
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
 