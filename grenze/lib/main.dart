import 'package:provider/provider.dart';
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:logger/logger.dart";
import "package:salomon_bottom_bar/salomon_bottom_bar.dart";
import "package:google_fonts/google_fonts.dart";
import 'package:flutter_localizations/flutter_localizations.dart';

import "friend.dart";
import "myself.dart";
import "register.dart";
import 'user_data.dart';

const locale = Locale("ja", "JP");
var logger = Logger();

const testDataList = [
  {"x": 1.0, "y": 2.0},
  {"x": 3.0, "y": 4.0},
  {"x": 5.0, "y": 6.0},
];
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ChangeNotifierProvider<UserDataProvider>(
      create: (context) => UserDataProvider(), child: const MyApp()));
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

  //ページ起動時に呼ばれる初期化関数
  @override
  void initState() {
    super.initState();

    context
        .read<UserDataProvider>()
        .setTimerFunc(900, context.read<UserDataProvider>().updateUserData);
    context.read<UserDataProvider>().initMain();
  }

  //registerページに画面遷移
  void moveToRegister() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => const RegisterPage(),
      ),
    );
  }

  //ページ移動系
  void _onItemTapped(int index) {
    setState(() {
      _pageViewController.animateToPage(index,
          duration: const Duration(milliseconds: 100), curve: Curves.easeOut);
    });
  }

  @override
  Widget build(BuildContext context) {
    final UserDataProvider userDataProvider =
        Provider.of<UserDataProvider>(context, listen: true);
    if (userDataProvider.userId == null) {
      return Scaffold(
          appBar: AppBar(
            //オーバーレイが明るいカラースキームになります。
            systemOverlayStyle: SystemUiOverlayStyle.light,
            title: const Text("Register"),
            centerTitle: true,
          ),
          body: const Register());
    } else {
      return Scaffold(
        body: PageView(
          controller: _pageViewController,
          children: const <Widget>[
            MyselfPage(),
            FriendPage(),
          ],
          onPageChanged: (index) {
            userDataProvider.setPageIndex(index);
          },
        ),
        bottomNavigationBar: SalomonBottomBar(
            backgroundColor: const Color.fromARGB(255, 178, 211, 244),
            currentIndex: userDataProvider.pageIndex,
            selectedItemColor: const Color(0xff6200ee),
            unselectedItemColor: const Color(0xff757575),
            onTap: _onItemTapped,
            items: [
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
                  title: Text("Friends",
                      style: GoogleFonts.orelegaOne(fontSize: 20)),
                  selectedColor: Colors.pink)
            ]),
      );
    }
  }
}

class Register extends StatelessWidget {
  const Register({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}

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
