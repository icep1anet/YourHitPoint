import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:provider/provider.dart";
import "package:logger/logger.dart";

import "user_data.dart";
import "oauth_fitbit.dart";

var logger = Logger();

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
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
    final UserDataProvider userDataProvider =
        Provider.of<UserDataProvider>(context, listen: true);
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
                                var response =
                                    await userDataProvider.registerFirebase(
                                  _registering,
                                  _emailController!.text,
                                  _passwordController!.text,
                                );
                                if (response["isCompleted"] == true) {
                                  // メイン画面へ遷移
                                  if (context.mounted) {
                                    navigateMain();
                                  }
                                } else {
                                  logger.d(response);
                                  if (context.mounted) {
                                    setState(() {
                                      _registering = false;
                                    });
                                    await showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text("OK"),
                                          ),
                                        ],
                                        content: Text(
                                          response["error"].toString(),
                                        ),
                                        title: const Text("Error"),
                                      ),
                                    );
                                  }
                                }
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
                                var response =
                                    await userDataProvider.registerFirebase(
                                  _registering,
                                  _emailController!.text,
                                  _passwordController!.text,
                                );
                                if (response["isCompleted"] == true) {
                                  // メイン画面へ遷移
                                  if (context.mounted) {
                                    navigateMain();
                                  }
                                } else {
                                  logger.d(response);
                                  if (context.mounted) {
                                    setState(() {
                                      _registering = false;
                                    });
                                    await showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text("OK"),
                                          ),
                                        ],
                                        content: Text(
                                          response["error"].toString(),
                                        ),
                                        title: const Text("Error"),
                                      ),
                                    );
                                  }
                                }
                              }
                            },
                            child: const Text(
                              "新規登録",
                              style: TextStyle(fontSize: 23),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 60),
                      ElevatedButton(
                          onPressed: () async {
                            if (_registering == false) {
                              setState(() {
                                _registering = true;
                              });
                              await FitbitAPI.callOAuth();
                              userDataProvider.accessToken =
                                  await FitbitAPI.getToken();
                              if (userDataProvider.accessToken != null) {
                                logger.d("認証できましたよ");
                                var profile = await FitbitAPI.getProfile();
                                userDataProvider.userId = profile["user"]["encodedId"];
                                userDataProvider.userName = profile["user"]["displayName"];
                                userDataProvider.gender = profile["user"]["gender"];
                                profile["fitbit_id"] = userDataProvider.userId;
                                profile["avatar_name"] = userDataProvider.avatarName;
                                profile["avatar_type"] = userDataProvider.avatarType;
                                // firebase登録のためのrequestを送る

                                navigateMain();
                              } else {
                                logger.d("認証できませんでした泣");
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 65, 186, 227),
                            elevation: 16,
                          ),
                          child: const Text("calloauth",
                              style: TextStyle(
                                fontSize: 30,
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                              ))),
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
    await Navigator.pushNamedAndRemoveUntil(
      context,
      "/home",
      (route) => false,
    );
  }
}
