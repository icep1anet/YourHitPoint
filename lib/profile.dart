import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:fluttericon/octicons_icons.dart";
import "package:provider/provider.dart";
import "package:logger/logger.dart";

import "user_data.dart";

var logger = Logger();

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  FocusNode? _focusUserNameNode;
  FocusNode? _focusAvatarNameNode;
  TextEditingController? _userNameController;
  final _registering = false;
  TextEditingController? _avatarNameController;
  // String avatarType = "猫";
  String? selectAvatarType;
  String? userId;
  // List<String> choices = ["猫", "犬", "人間男", "ワニ", "フクロウ", "カブトムシ"];
  List<DropdownMenuItem<String>> dropdownMenuItems = const [
    DropdownMenuItem(
      value: "neko",
      child: Text("猫"),
    ),
    DropdownMenuItem(
      value: "inu",
      child: Text("犬"),
    ),
    DropdownMenuItem(
      value: "man",
      child: Text("人間男"),
    ),
    DropdownMenuItem(
      value: "wani",
      child: Text("ワニ"),
    ),
    DropdownMenuItem(
      value: "hukurou",
      child: Text("フクロウ"),
    ),
    DropdownMenuItem(
      value: "kabutomushi",
      child: Text("カブトムシ"),
    ),
  ];

  //ページ起動時に呼ばれる初期化関数
  @override
  void initState() {
    super.initState();
    _focusUserNameNode = FocusNode();
    _focusAvatarNameNode = FocusNode();
  }

  @override
  void dispose() {
    _focusUserNameNode?.dispose();
    _focusAvatarNameNode?.dispose();
    _userNameController?.dispose();
    _avatarNameController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final UserDataProvider userDataProvider =
        Provider.of<UserDataProvider>(context, listen: true);
    return Focus(
        focusNode: _focusUserNameNode,
        child: GestureDetector(
            onTap: () {
              _focusUserNameNode?.requestFocus();
            },
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                backgroundColor: const Color(0xff00a5bf),
                systemOverlayStyle: SystemUiOverlayStyle.light,
                title: const Text(
                  "Profile settings",
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
                        controller: _userNameController = TextEditingController(
                            text: userDataProvider.userName),
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ),
                          ),
                          labelText: "ユーザーネーム",
                          labelStyle: const TextStyle(fontSize: 25),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.cancel),
                            onPressed: () => _userNameController?.clear(),
                          ),
                        ),
                        keyboardType: TextInputType.text,
                        onEditingComplete: () {
                          _focusAvatarNameNode?.requestFocus();
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
                          controller: _avatarNameController =
                              TextEditingController(
                                  text: userDataProvider.avatarName),
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8),
                              ),
                            ),
                            labelText: "アバターネーム",
                            labelStyle: const TextStyle(fontSize: 25),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.cancel),
                              onPressed: () => _avatarNameController?.clear(),
                            ),
                          ),
                          focusNode: _focusAvatarNameNode,
                          keyboardType: TextInputType.text,
                          onEditingComplete: () {
                            _focusAvatarNameNode?.unfocus();
                          },
                          textCapitalization: TextCapitalization.none,
                          textInputAction: TextInputAction.done,
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(right: 10, top: 10),
                        child: const Text("アバタータイプ",
                            style: TextStyle(
                                fontSize: 18, color: Color(0xff696969))),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: const Color(0xff696969), width: 1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: DropdownButton(
                          style: const TextStyle(
                              fontSize: 25, color: Colors.black),
                          items: dropdownMenuItems,
                          value: selectAvatarType = userDataProvider.avatarType,
                          alignment: Alignment.center,
                          onChanged: (String? value) {
                            setState(() {
                              selectAvatarType = value!;
                            });
                          },
                          icon: const Padding(
                              padding: EdgeInsets.only(left: 20),
                              child: Icon(
                                Octicons.triangle_down,
                                size: 15,
                              )),
                          iconEnabledColor: const Color(0xff696969),
                          dropdownColor: Colors.white,
                          underline: Container(),
                        ),
                      ),
                      const SizedBox(height: 30),
                      TextButton(
                        onPressed: () async {
                          // firstNameとlastNameは必須で入力しないと登録できないようにする
                          if (_registering == false &&
                              _userNameController!.text != "" &&
                              _avatarNameController!.text != "") {
                            FocusScope.of(context).unfocus();
                            // var response =
                            //     await userDataProvider.registerFirebase(
                            //         _registering,
                            //         _userNameController!.text,
                            //         _avatarNameController!.text,
                            //         selectAvatarType,
                            //         );
                            // if (response["isCompleted"] == true) {
                            //   // メイン画面へ遷移
                            //   if (context.mounted) {
                            //     navigateMain();
                            //   }
                            // } else {
                            //   if (context.mounted) {
                            //     await showDialog(
                            //       context: context,
                            //       builder: (context) => AlertDialog(
                            //         actions: [
                            //           TextButton(
                            //             onPressed: () {
                            //               Navigator.of(context).pop();
                            //             },
                            //             child: const Text("OK"),
                            //           ),
                            //         ],
                            //         content: Text(
                            //           response["error"],
                            //         ),
                            //         title: const Text("Error"),
                            //       ),
                            //     );
                            //   }
                            // }
                          }
                        },
                        child: const Text(
                          "プロフィール変更",
                          style: TextStyle(fontSize: 23),
                        ),
                      ),
                      const SizedBox(height: 5),
                      //ローディング
                      if (_registering == true)
                        const CircularProgressIndicator(),
                      if (userId != null) Text(userId!),
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