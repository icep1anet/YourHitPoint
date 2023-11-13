import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:logger/logger.dart";
import 'package:your_hit_point/view_model/user_data_notifier.dart';

import 'package:your_hit_point/client/oauth_fitbit.dart';
import 'package:your_hit_point/client/firebase_authentication.dart';

var logger = Logger();

class OAuthPage extends ConsumerStatefulWidget {
  const OAuthPage({super.key});

  @override
  OAuthPageState createState() => OAuthPageState();
}

class OAuthPageState extends ConsumerState<OAuthPage> {
  bool _registering = false;
  String? userId;

  //ページ起動時に呼ばれる初期化関数
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: const Color(0xff00a5bf),
        systemOverlayStyle: SystemUiOverlayStyle.light,
        title: const Text(
          "OAuth",
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(top: 40, left: 24, right: 24),
          child: Center(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              // mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 300),
                ElevatedButton(
                  onPressed: () async {
                    if (_registering == false) {
                      setState(() => _registering = true);
                      await callOAuth();
                      String? accessToken = await getToken();
                      ref.watch(accessTokenProvider.notifier).state =
                        accessToken;
                      if (accessToken != null) {
                        logger.d("認証できましたよ");
                        final userId = ref.read(userIdProvider);
                        await ref
                          .read(userDataProvider.notifier)
                          .registerFirebase(userId);
                        setState(() => _registering = false);
                      } else {
                        logger.d("認証できませんでした泣");
                        setState(() => _registering = false);
                      }
                    }
                  },
                    child: const SizedBox(
                      height: 60,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ClipOval(
                            child: Image(
                                image: AssetImage(
                                    "assets/images/fitbit_icon.png"),
                                width: 30,
                                height: 30,
                                fit: BoxFit.fill),
                          ),
                          SizedBox(width: 10),
                          Text("Fitbitと連携する",
                              style: TextStyle(
                                fontSize: 20,
                                color: Color.fromARGB(255, 0, 0, 0),
                                // fontWeight: FontWeight.bold,
                                // fontStyle: FontStyle.italic,
                              )),
                        ],
                      ),
                    )),
                const SizedBox(height: 50),
                //ローディング
                if (_registering == true)
                  const CircularProgressIndicator(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void navigateMain() async {
    logger.d("navigateMain");
    await Navigator.pushNamedAndRemoveUntil(
      context,
      "/home",
      (route) => false,
    );
  }
}
