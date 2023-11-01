import 'package:provider/provider.dart';
import "package:flutter/material.dart";
import "package:logger/logger.dart";
import "package:salomon_bottom_bar/salomon_bottom_bar.dart";
import "package:google_fonts/google_fonts.dart";

import "friend.dart";
import "myself.dart";
import "register.dart";
import 'user_data.dart';

var logger = Logger();

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
    if (userDataProvider.finishMain == false) {
      return const Scaffold(
          body: Center(
        child: CircularProgressIndicator(),
      ));
    } else {
      if (userDataProvider.userId == null) {
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
}