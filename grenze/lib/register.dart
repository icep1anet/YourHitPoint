import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:fluttericon/octicons_icons.dart";
import "package:grenze/user_data.dart";
import "package:provider/provider.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:logger/logger.dart";
import "dart:convert";
import "package:http/http.dart" as http;

var logger = Logger();

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  FocusNode? _focusUserNameNode;
  FocusNode? _focusAvatarNameNode;
  TextEditingController? _userNameController;
  bool _registering = false;
  TextEditingController? _avatarNameController;
  //画像のローカルパス
  // File? imagePath;
  // String userId = FirebaseAuth.instance.currentUser!.uid;
  // String? userId;
  // XFile? pickerFile;
  String? imageUrl;
  bool? hasData;
  List<String> choices = ["猫", "犬", "フクロウ", "カブトムシ", "亀"];
  String avatarType = "猫";
  String? userId;

  //ページ起動時に呼ばれる初期化関数
  @override
  void initState() {
    super.initState();
    // initializeFlutterFire();
    // initSharedPreferences();
    // _getPrefItems();
    _focusUserNameNode = FocusNode();
    _focusAvatarNameNode = FocusNode();
    _userNameController = TextEditingController(text: "多喜男");
    _avatarNameController = TextEditingController(text: "ガララワニ");
  }

  @override
  void dispose() {
    _focusUserNameNode?.dispose();
    _focusAvatarNameNode?.dispose();
    _userNameController?.dispose();
    _avatarNameController?.dispose();
    super.dispose();
  }

  _setPrefItems(String userId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("userId", userId);
  }

  _getPrefItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString("userId");
    });
    if (userId == null) {
      logger.d("no");
    } else {
      logger.d("yes");
    }
  }

  // void addUserToFirestore(String userName, String avatarName, int avatarType) async{
  //   CollectionReference users = FirebaseFirestore.instance.collection("users");

  //   await users.doc("test").collection("user_info").doc("user_data").set({
  //     "userName": _userNameController!.text,
  //     "avatarName": _avatarNameController!.text,
  //     "avatarType": avatarType,
  //   }).then((value) {
  //     logger.d("User added successfully!");
  //   }).catchError((error) {
  //     logger.d("Failed to add user: $error");
  //   });
  // }

  @override
  Widget build(BuildContext context) {
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
                actions: [
                  //   if (hasData != null)
                  //     IconButton(
                  //       onPressed: () {
                  //         showQRcode(userId);
                  //       },
                  //       icon: const Icon(Icons.qr_code_2),
                  //       color: Colors.pink,
                  //       iconSize: 35,
                  //     ),
                  IconButton(
                      onPressed: () {
                        _setPrefItems("12345kusa");
                      },
                      icon: const Icon(Icons.add)),
                  IconButton(
                      onPressed: () {
                        _getPrefItems();
                      },
                      icon: const Icon(Icons.add)),
                ],
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
                        controller: _userNameController,
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
                          controller: _avatarNameController,
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
                      /*
                      dropdownColor：ドロップダウンの背景色
                      elevation：リストを開いた時の影の濃さ
                      icon：ドロップダウンボタンのアイコン
                      iconSize：ドロップダウンボタンのアイコンの大きさ
                      itemHeight：リストの高さ
                      style：テキストスタイル
                      underline：ドロップダウンボタンの下線
                      */
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
                        // height: 50,
                        decoration: BoxDecoration(
                          border: Border.all(
                              // right: BorderSide(),
                              color: const Color(0xff696969),
                              width: 1),
                          borderRadius: BorderRadius.circular(10),
                        ),

                        child: DropdownButton(
                          style: const TextStyle(
                              fontSize: 25, color: Colors.black),
                          items: choices
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              alignment: Alignment.centerLeft,
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          value: avatarType,
                          alignment: Alignment.center,
                          onChanged: (String? value) {
                            setState(() {
                              avatarType = value!;
                            });
                          },
                          icon: const Padding(
                              //Icon at tail, arrow bottom is default icon
                              padding: EdgeInsets.only(left: 20),
                              child: Icon(
                                Octicons.triangle_down,
                                size: 15,
                              )),
                          iconEnabledColor:
                              const Color(0xff696969), //Icon color
                          dropdownColor:
                              Colors.white, //dropdown background color
                          underline: Container(), //remove underline
                          // isExpanded: true,
                        ),
                      ),

                      // Container(
                      //     margin: const EdgeInsets.only(top: 16),
                      //     child: Row(
                      //         mainAxisAlignment: MainAxisAlignment.center,
                      //         children: [
                      //           ElevatedButton(
                      //             onPressed: () {
                      //               _focusUserNameNode?.requestFocus();
                      //               _selectImage();
                      //             },
                      //             style: ElevatedButton.styleFrom(
                      //               backgroundColor: Colors.green,
                      //               elevation: 16,
                      //             ),
                      //             child: imagePath == null &&
                      //                     imageUrl == null
                      //                 ? const Text("Set Image")
                      //                 : const Text("Change Image"),
                      //           ),
                      //           IconButton(
                      //             onPressed: () {
                      //               _focusUserNameNode?.requestFocus();
                      //               setState(() {
                      //                 imagePath = null;
                      //                 imageUrl = null;
                      //                 pickerFile = null;
                      //               });
                      //             },
                      //             icon: const Icon(Icons.cancel),
                      //             iconSize: 35,
                      //             color: Colors.blue,
                      //           )
                      //         ])),
                      // const SizedBox(height: 30),
                      // //表示する画像はfirestrorageのものではなくローカルで表示
                      // imagePath != null
                      //     ? _buildmyAvatar(imagePath)
                      //     : _currentmyAvatar(imageUrl),

                      const SizedBox(height: 30),
                      TextButton(
                        // style: TextButton.styleFrom(
                        //   side: BorderSide(
                        //     color: Color(0xff483d8b)
                        //   )
                        // ),
                        onPressed: () {
                          // firstNameとlastNameは必須で入力しないと登録できないようにする
                          if (_registering == false &&
                              _userNameController!.text != "" &&
                              _avatarNameController!.text != "") {
                            registerFirebase();
                          }
                        },
                        child: hasData != null
                            ? const Text(
                                "プロフィール変更",
                                style: TextStyle(fontSize: 23),
                              )
                            : const Text(
                                "プロフィール登録",
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

  // void initializeFlutterFire() async {
  //   _focusUserNameNode = FocusNode();
  //   _focusAvatarNameNode = FocusNode();
  //   DocumentSnapshot snapshot =
  //       await FirebaseChatCore.instance.getUserData(userId);
  //   if (snapshot.exists) {
  //     setState(() {
  //       hasData = true;
  //     });
  //     _userNameController = TextEditingController(text: snapshot["firstName"]);
  //     _avatarNameController = TextEditingController(
  //       text: snapshot["lastName"],
  //     );
  //     imageUrl = snapshot["imageUrl"];
  //   } else {
  //     _userNameController = TextEditingController(text: "");
  //     _avatarNameController = TextEditingController(text: "");
  //   }
  // }

  //responseを送ってfirebaseにデータ登録する
  Future<void> registerFirebase() async {
    FocusScope.of(context).unfocus();
    setState(() {
      _registering = true;
    });
    logger.d("startttttt");
    // var url =
    //   Uri.https("o2nr395oib.execute-api.ap-northeast-1.amazonaws.com", "/default/get_HP_data",
    var url = Uri.https("vignp7m26e.execute-api.ap-northeast-1.amazonaws.com",
        "/default/register_firebase_yourHP", {
      "userName": _userNameController!.text,
      "avatarName": _avatarNameController!.text,
      "avatarType": avatarType
    });
    try {
      var response = await http.get(url);
      logger.d(response.body);
      if (response.statusCode == 200) {
        // リクエストが成功した場合、レスポンスの内容を取得して表示します
        // logger.d(response.body);

        var responseMap = jsonDecode(response.body);
        userId = responseMap["userId"];
        logger.d(userId);
        // if (!mounted) return;
        if (context.mounted){
          context.read<UserDataProvider>().setItemToSharedPref(
            ["userId", "userName",
             "avatarName", "avatarType"], 
            [userId!, _userNameController!.text,
             _avatarNameController!.text, avatarType]
            );
        }
        WidgetsBinding.instance.addPostFrameCallback((_) {
          navigateMain();
        });
        
      } else {
        // リクエストが失敗した場合、エラーメッセージを表示します
        logger.d("Request failed with status: ${response.statusCode}");
        setState(() {
          _registering = false;
        });
      }
    } catch (e) {
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
            e.toString(),
          ),
          title: const Text("Error"),
        ),
      );
    }
  }

  // void _register() async {
  //   FocusScope.of(context).unfocus();
  //   setState(() {
  //     _registering = true;
  //   });

  //   await showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       actions: [
  //         TextButton(
  //           onPressed: () {
  //             Navigator.of(context).pop();
  //           },
  //           child: const Text("OK"),
  //         ),
  //       ],
  //       content: Text(
  //         e.toString(),
  //       ),
  //       title: const Text("Error"),
  //     ),
  //   );
  // }
  // }

  void navigateMain() async {
    await Navigator.pushNamedAndRemoveUntil(
      context,
      "/home",
      (route) => false,
    );
  }

  // void _selectImage() async {
  //   pickerFile = await ImagePicker().pickImage(source: ImageSource.gallery);
  //   if (pickerFile == null) {
  //     setState(() {
  //       _registering = false;
  //     });
  //     return;
  //   }
  //   File file = File(pickerFile!.path);
  //   setState(() {
  //     imagePath = file;
  //   });
  // }

  // Widget _buildmyAvatar(File? path) {
  //   var color = getmyAvatarNameColor(userId);
  //   final hasImage = path != null;
  //   return Container(
  //     margin: const EdgeInsets.only(right: 16),
  //     child: CircleAvatar(
  //       backgroundColor: hasImage ? Colors.transparent : color,
  //       backgroundImage: hasImage ? FileImage(imagePath!) : null,
  //       radius: 60,
  //       child: !hasImage
  //           ? const Text(
  //               "no image",
  //             )
  //           : null,
  //     ),
  //   );
  // }
}
