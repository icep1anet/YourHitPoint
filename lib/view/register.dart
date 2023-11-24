import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:logger/logger.dart";
import 'package:your_hit_point/client/firebase_authentication.dart';
import 'package:your_hit_point/components/validate_text.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';

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
  TextEditingController? _passwordController;
  String? userId;
  bool _registering = false;
  bool isVisible = false;
  AutovalidateMode emailValidate = AutovalidateMode.disabled;
  bool passwordVal = false;

  //ページ起動時に呼ばれる初期化関数
  @override
  void initState() {
    super.initState();
    _registering = false;
    _focusEmailNode = FocusNode();
    _focusPasswordNode = FocusNode();
    _emailController = TextEditingController(text: "");
    _passwordController = TextEditingController(text: "");
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
                      TextFormField(
                        autovalidateMode: emailValidate,
                        validator: ValidateText.email,
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
                        child: TextFormField(
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
                            suffixIcon: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(isVisible
                                      ? Icons.visibility_off
                                      : Icons.visibility),
                                  onPressed: () => toggleShowPassword(),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.cancel),
                                  onPressed: () => _passwordController?.clear(),
                                ),
                              ],
                            ),
                          ),
                          focusNode: _focusPasswordNode,
                          keyboardType: TextInputType.text,
                          obscureText: !isVisible,
                          onEditingComplete: () {
                            _focusPasswordNode?.unfocus();
                          },
                          textCapitalization: TextCapitalization.none,
                          textInputAction: TextInputAction.done,
                        ),
                      ),
                      FlutterPwValidator(
                          controller: _passwordController!,
                          minLength: 8,
                          uppercaseCharCount: 1,
                          lowercaseCharCount: 1,
                          numericCharCount: 1,
                          specialCharCount: 1,
                          width: 400,
                          height: 200,
                          onSuccess: () {
                            passwordVal = true;
                          },
                          onFail: () {
                            passwordVal = false;
                          }),
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
                                setState(() => _registering = true);
                                FocusScope.of(context).unfocus();
                                String? emailVal =
                                    ValidateText.email(_emailController!.text);
                                if (emailVal == null && passwordVal) {
                                  await signIn(_emailController!.text,
                                      _passwordController!.text, ref);
                                  setState(() => _registering = false);
                                } else {
                                  setState(() {
                                    emailValidate =
                                        AutovalidateMode.onUserInteraction;
                                    _registering = false;
                                  });
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
                                setState(() => _registering = true);
                                FocusScope.of(context).unfocus();
                                String? emailVal =
                                    ValidateText.email(_emailController!.text);
                                if (emailVal == null && passwordVal) {
                                  await createAccount(_emailController!.text,
                                      _passwordController!.text, ref);
                                  setState(() => _registering = false);
                                } else {
                                  setState(() {
                                    emailValidate =
                                        AutovalidateMode.onUserInteraction;
                                    _registering = false;
                                  });
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
                      const SizedBox(height: 20),
                      if (ref.watch(errorMessageProvider) != null)
                        Text(
                          ref.read(errorMessageProvider).toString(),
                          style:
                              const TextStyle(color: Colors.red, fontSize: 20),
                        ),
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

  void toggleShowPassword() {
    setState(() {
      isVisible = !isVisible;
    });
  }
}
