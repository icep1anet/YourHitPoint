import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:flutter/material.dart";
import "package:logger/logger.dart";
import "package:salomon_bottom_bar/salomon_bottom_bar.dart";
import "package:google_fonts/google_fonts.dart";
import 'package:bordered_text/bordered_text.dart';
import 'package:your_hit_point/client/firebase_authentication.dart';
import 'package:your_hit_point/client/oauth_fitbit.dart';
import 'package:your_hit_point/utils/timer_func.dart';
import 'package:your_hit_point/view/oauth.dart';
import 'package:your_hit_point/view_model/HP_notifier.dart';
import 'package:your_hit_point/view/friend.dart';
import 'package:your_hit_point/view/register.dart';
import 'package:your_hit_point/view/myself.dart';

var logger = Logger();

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
    setTimerFunc(900, ref.read(hpProvider.notifier).requestHP, ref);
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
    final firebaseAuthState = ref.watch(firebaseAuthStateProvider);
    final isFinishedMain = ref.watch(isFinishedMainProvider);
    final accessToken = ref.watch(accessTokenProvider);

    if (isFinishedMain) {
      return firebaseAuthState.when(
          data: (user) {
            if (user == null) {
              // registerページへ
              return const RegisterPage();
            } else {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ref.watch(userIdProvider.notifier).state = user.uid;
              });
              if (accessToken == null) {
                return const OAuthPage();
                // firebase Auth + fitbit OAuthが通っている時
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
                          title: BorderedText(
                            strokeWidth: 2,
                            strokeColor: Colors.black,
                            child: Text(
                              "Myself",
                              //iconが真ん中startなのでできない
                              // textAlign: TextAlign.left,
                              style: GoogleFonts.orelegaOne(fontSize: 20),
                            ),
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
          },
          error: (err, stack) => Text('Error: $err'),
          loading: () => const Scaffold(
                  body: Center(
                child: CircularProgressIndicator(),
              )));
    } else {
      return const Scaffold(
          body: Center(
        child: CircularProgressIndicator(),
      ));
    }
  }
}
