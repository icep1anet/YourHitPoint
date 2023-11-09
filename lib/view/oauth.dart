import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:logger/logger.dart";
import 'package:your_hit_point/view_model/user_data_notifier.dart';

import 'package:your_hit_point/client/oauth_fitbit.dart';

var logger = Logger();

class OAuthPage extends ConsumerStatefulWidget {
  const OAuthPage({super.key});

  @override
  OAuthPageState createState() => OAuthPageState();
}

class OAuthPageState extends ConsumerState<OAuthPage> {
  FocusNode? _focusEmailNode;
  FocusNode? _focusPasswordNode;
  TextEditingController? _emailController;
  bool _registering = false;
  TextEditingController? _passwordController;
  String? userId;

  //ページ起動時に呼ばれる初期化関数
  @override
  void initState() {
    super.initState();
    _focusEmailNode = FocusNode();
    _focusPasswordNode = FocusNode();
    _emailController = TextEditingController(text: "abcde@gmail.com");
    _passwordController = TextEditingController(text: "asdfgh");
  }

  @override
  void dispose() {
    _focusEmailNode?.dispose();
    _focusPasswordNode?.dispose();
    _emailController?.dispose();
    _passwordController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
        focusNode: _focusEmailNode,
        child: GestureDetector(
            onTap: () {
              _focusEmailNode?.requestFocus();
            },
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                backgroundColor: const Color(0xff00a5bf),
                systemOverlayStyle: SystemUiOverlayStyle.light,
                title: const Text(
                  "Register",
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
                                setState(() {
                                  _registering = true;
                                });
                                await callOAuth();
                                String? accessToken = await getToken();
                                ref.watch(accessTokenProvider.notifier).state =
                                    accessToken;
                                if (accessToken != null) {
                                  logger.d("認証できましたよ");
                                  bool registerFlag = await ref
                                      .read(userDataProvider.notifier)
                                      .registerFirebase();
                                  if (registerFlag) {
                                    navigateMain();
                                  } else {
                                    setState(() {
                                      _registering = false;
                                    });
                                  }
                                } else {
                                  logger.d("認証できませんでした泣");
                                  setState(() {
                                    _registering = false;
                                  });
                                }
                              }
                            },
                            // style: ElevatedButton.styleFrom(
                            //   backgroundColor:
                            //       Colors.white,
                            //   elevation: 16,
                            // ),
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
                                  Text("Fitbitでログインする",
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
            )));
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
