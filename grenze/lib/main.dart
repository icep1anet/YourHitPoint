import 'package:flutter/material.dart';
import "myself.dart";

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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            // activeIcon: Icon(Icons.book_online),
            label: 'Myself',
            tooltip: "My Page",
            backgroundColor: Color.fromARGB(255, 103, 219, 234),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            // activeIcon: Icon(Icons.school_outlined),
            label: 'Friends',
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
        unselectedIconTheme: const IconThemeData(size: 25, color: Colors.white),
      ),
    );
  }
}
