import 'package:flutter/material.dart';
import "myself.dart";
import "register.dart";
import "package:shared_preferences/shared_preferences.dart";
import 'package:flutter/services.dart';

String? userId;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MainPage(),
      routes: {
        '/home': (context) => const MainPage(),
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

  

  @override
  void initState() {
    super.initState();
    _getPrefItems();
  }

  void moveToRegister() async{
    await Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => const RegisterPage(),
      ),
    );
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString("userId");
    });
  }

  void _getPrefItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString("userId");
    });
  }

  

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageViewController.animateToPage(index,
          duration: const Duration(milliseconds: 100), curve: Curves.easeOut);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (userId == null) {
      print("null");
      return Scaffold(
        appBar: AppBar(
          //オーバーレイが明るいカラースキームになります。
          systemOverlayStyle: SystemUiOverlayStyle.light,
          title: const Text('Register'),
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
              const Text('Not registered'),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      fullscreenDialog: true,
                      builder: (context) => const RegisterPage(),
                    ),
                  );
                },
                child: const Text('Register'),
              ),
            ],
          ),
        ));
    } else{
    print("hasdata");
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
    );}
  }
}
