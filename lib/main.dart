import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:flutter/material.dart";
import "package:logger/logger.dart";
import "package:salomon_bottom_bar/salomon_bottom_bar.dart";
import "package:google_fonts/google_fonts.dart";
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:your_hit_point/client/oauth_fitbit.dart';
import 'package:your_hit_point/utils/timer_func.dart';
import 'package:your_hit_point/view_model/HP_notifier.dart';

import 'view/friend.dart';
import 'view/myself.dart';
import 'view/register.dart';

const locale = Locale("ja", "JP");
var logger = Logger();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MyApp()));
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

final isFinishedMainProvider = StateProvider<bool>((ref) => false);
final pageViewControllerProvider =
    StateProvider<PageController>((ref) => PageController());
final pageIndexProvider = StateProvider<int>((ref) => 0);

class MainPage extends ConsumerStatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends ConsumerState<MainPage> {
  //ページ起動時に呼ばれる初期化関数
  @override
  void initState() {
    super.initState();
    logger.d("hello world");
    ref.read(hpProvider.notifier).initMain(ref);
    setTimerFunc(900, ref.read(hpProvider.notifier).updateUserData, ref);
  }

  //ページ移動系
  void _onItemTapped(int index) {
    setState(() {
      ref.read(pageViewControllerProvider).animateToPage(index,
          duration: const Duration(milliseconds: 100), curve: Curves.easeOut);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isFinishedMain = ref.watch(isFinishedMainProvider);
    final accessToken = ref.watch(accessTokenProvider);
    if (isFinishedMain == false) {
      return const Scaffold(
          body: Center(
        child: CircularProgressIndicator(),
      ));
    } else {
      if (accessToken == null) {
        Future.microtask(() => Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                fullscreenDialog: true,
                builder: (context) => const RegisterPage(),
              ),
            ));

        return Container();
      } else {
        return Scaffold(
          body: PageView(
            controller: ref.watch(pageViewControllerProvider),
            children: const <Widget>[
              MyselfPage(),
              FriendPage(),
            ],
            onPageChanged: (index) {
              ref.watch(pageIndexProvider.notifier).state = index;
            },
          ),
          bottomNavigationBar: SalomonBottomBar(
              backgroundColor: const Color.fromARGB(255, 178, 211, 244),
              currentIndex: ref.watch(pageIndexProvider),
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
}

class Register extends StatelessWidget {
  const Register({super.key});

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
              //registerページに画面遷移
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
