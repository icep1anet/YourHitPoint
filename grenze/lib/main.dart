import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import "myself.dart";
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
// import "design.dart";
// import "asset_manifest.dart";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainPage(),
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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageViewController.animateToPage(index,
          duration: const Duration(milliseconds: 100), curve: Curves.easeOut);
    });
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
          backgroundColor: const Color.fromARGB(255, 179, 206, 233),
          currentIndex: _selectedIndex,
          selectedItemColor: const Color(0xff6200ee),
          unselectedItemColor: const Color(0xff757575),
          onTap:  _onItemTapped,
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
      style: GoogleFonts.orelegaOne(fontSize: 20),
    ),
    selectedColor:  Colors.green,
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
 