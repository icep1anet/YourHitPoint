import "package:flutter/material.dart";
import "package:flutter/services.dart";
// import "package:flutter_chat_types/flutter_chat_types.dart" as types;
// import "package:image_picker/image_picker.dart";
// import "dart:io";
// import "util.dart";
// import "package:qr_flutter/qr_flutter.dart";
import "main.dart";
import "package:shared_preferences/shared_preferences.dart";




class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  FocusNode? _fNode;
  FocusNode? _focusNode;
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


  @override
  void initState() {
    super.initState();
    // initializeFlutterFire();
    // initSharedPreferences();
    _getPrefItems();
    _userNameController = TextEditingController(text: "");
    _avatarNameController = TextEditingController(text: "");
  }

  @override
  void dispose() {
    _focusNode?.dispose();
    _userNameController?.dispose();
    _avatarNameController?.dispose();
    super.dispose();
  }
  // void initSharedPreferences() async{
  //   prefs = await SharedPreferences.getInstance();
  // }

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
      print("no");
    } else {
      print("yes");
    }
  }

  // void addUserToFirestore(String userName, String avatarName, int avatarType) async{
  //   CollectionReference users = FirebaseFirestore.instance.collection("users");
    
  //   await users.doc("test").collection("user_info").doc("user_data").set({
  //     "userName": _userNameController!.text,
  //     "avatarName": _avatarNameController!.text,
  //     "avatarType": avatarType,
  //   }).then((value) {
  //     print("User added successfully!");
  //   }).catchError((error) {
  //     print("Failed to add user: $error");
  //   });
  // }





  @override
  Widget build(BuildContext context) {
    return Focus(
        focusNode: _fNode,
        child: GestureDetector(
            onTap: () {
              _fNode?.requestFocus();
            },
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                systemOverlayStyle: SystemUiOverlayStyle.light,
                title: const Text("Profile"),
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
                    icon: const Icon(Icons.add)
                  ),
                  IconButton(
                    onPressed: () {
                      _getPrefItems();
                    }, 
                    icon: const Icon(Icons.add)
                  ),
                ],
              ),
              body: SingleChildScrollView(
                child: Container(
                  padding:
                      const EdgeInsets.only(top: 40, left: 24, right: 24),
                  child: Column(
                    children: [
                      // Text("UserID: $userId",
                      //     style: const TextStyle(
                      //         fontWeight: FontWeight.bold, fontSize: 15)),
                      // const SizedBox(height: 15),
                      TextField(
                        autocorrect: false,
                        autofocus: false,
                        controller: _userNameController,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ),
                          ),
                          labelText: "userName",
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.cancel),
                            onPressed: () =>
                                _userNameController?.clear(),
                          ),
                        ),
                        keyboardType: TextInputType.text,
                        onEditingComplete: () {
                          _focusNode?.requestFocus();
                        },
                        readOnly: _registering,
                        textCapitalization: TextCapitalization.none,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 10),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: TextField(
                          autocorrect: false,
                          controller: _avatarNameController,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8),
                              ),
                            ),
                            labelText: "avatarName",
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.cancel),
                              onPressed: () =>
                                  _avatarNameController?.clear(),
                            ),
                          ),
                          focusNode: _focusNode,
                          keyboardType: TextInputType.text,
                          onEditingComplete: () {
                            _focusNode?.unfocus();
                          },
                          textCapitalization: TextCapitalization.none,
                          textInputAction: TextInputAction.done,
                        ),
                      ),
                      
                      // Container(
                      //     margin: const EdgeInsets.only(top: 16),
                      //     child: Row(
                      //         mainAxisAlignment: MainAxisAlignment.center,
                      //         children: [
                      //           ElevatedButton(
                      //             onPressed: () {
                      //               _fNode?.requestFocus();
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
                      //               _fNode?.requestFocus();
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
                        onPressed: () {
                          //firstNameとlastNameは必須で入力しないと登録できないようにする
                          // if (_registering == false &&
                          //     _userNameController?.text != "" &&
                          //     _avatarNameController?.text != "") {
                          //   _register();
                          // }
                          _register();
                        },
                        child: hasData != null
                            ? const Text("Change Profile")
                            : const Text("Profile Register"),
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
  //   _fNode = FocusNode();
  //   _focusNode = FocusNode();
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

  void _register() async {
    FocusScope.of(context).unfocus();
    setState(() {
      _registering = true;
    });
    // FirebaseStorage storage = FirebaseStorage.instance;
    try {
      // final storageRef = storage.ref("UL/profile_$userId.png");
      // if (pickerFile != null) {
      //   //purFileだとうまくできなかったのでputData
      //   await storageRef.putData(await pickerFile!.readAsBytes());
      //   imageUrl = await storageRef.getDownloadURL();
      // }

      // await FirebaseChatCore.instance.createUserInFirestore(
      //   types.User(
      //     firstName: _userNameController!.text,
      //     id: userId!,
      //     // imageUrl: imageUrl,
      //     lastName: _avatarNameController!.text,
      //   ),
      // );

      // if (!mounted) return;
      Navigator.of(context).pop();
      // await Navigator.of(context).push(
      //   MaterialPageRoute(
      //     fullscreenDialog: true,
      //     builder: (context) => const MainPage(),
      //   ),
      // );
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

  // Widget _currentmyAvatar(String? imgUrl) {
  //   var color = getmyAvatarNameColor(userId);
  //   final hasImage = imgUrl != null;
  //   return Container(
  //     margin: const EdgeInsets.only(right: 16),
  //     child: CircleAvatar(
  //       backgroundColor: hasImage ? Colors.transparent : color,
  //       backgroundImage: hasImage ? NetworkImage(imgUrl) : null,
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

