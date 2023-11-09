import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:logger/logger.dart";

import 'package:your_hit_point/client/oauth_fitbit.dart';
import "package:your_hit_point/view_model/user_data_notifier.dart";

var logger = Logger();

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends ConsumerState<RegisterPage> {
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
                  child: Column(
                    children: [
                      TextField(
                        style: const TextStyle(fontSize: 20),
                        autocorrect: false,
                        autofocus: false,
                        controller: _emailController,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ),
                          ),
                          labelText: "E-mail",
                          labelStyle: const TextStyle(fontSize: 25),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.cancel),
                            onPressed: () => _emailController?.clear(),
                          ),
                        ),
                        keyboardType: TextInputType.text,
                        onEditingComplete: () {
                          _focusPasswordNode?.requestFocus();
                        },
                        readOnly: _registering,
                        textCapitalization: TextCapitalization.none,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 40),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: TextField(
                          style: const TextStyle(fontSize: 20),
                          autocorrect: false,
                          controller: _passwordController,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8),
                              ),
                            ),
                            labelText: "Password",
                            labelStyle: const TextStyle(fontSize: 25),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.cancel),
                              onPressed: () => _passwordController?.clear(),
                            ),
                          ),
                          focusNode: _focusPasswordNode,
                          keyboardType: TextInputType.text,
                          obscureText: true,
                          onEditingComplete: () {
                            _focusPasswordNode?.unfocus();
                          },
                          textCapitalization: TextCapitalization.none,
                          textInputAction: TextInputAction.done,
                        ),
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () async {
                              // emailとpasswordは必須で入力しないと登録できないようにする
                              if (_registering == false &&
                                  _emailController!.text != "" &&
                                  _passwordController!.text != "") {
                                setState(() {
                                  _registering = true;
                                });
                                FocusScope.of(context).unfocus();
                                //registerの処理を書く



                              }
                            },
                            child: const Text(
                              "ログイン",
                              style: TextStyle(fontSize: 23),
                            ),
                          ),
                          const SizedBox(width: 30),
                          TextButton(
                            onPressed: () async {
                              // emailとpasswordは必須で入力しないと登録できないようにする
                              if (_registering == false &&
                                  _emailController!.text != "" &&
                                  _passwordController!.text != "") {
                                setState(() {
                                  _registering = true;
                                });
                                FocusScope.of(context).unfocus();
                                //loginの処理を書く



                              }
                            },
                            child: const Text(
                              "新規登録",
                              style: TextStyle(fontSize: 23),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      //ローディング
                      if (_registering == true)
                        const CircularProgressIndicator(),
                    ],
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
