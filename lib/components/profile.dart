import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:fluttericon/octicons_icons.dart";
import 'package:flutter_riverpod/flutter_riverpod.dart';
import "package:logger/logger.dart";

import "package:your_hit_point/view_model/user_data_notifier.dart";
import 'package:your_hit_point/utils/dropdown_items.dart';

var logger = Logger();

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends ConsumerState<ProfilePage> {
  FocusNode? _focusUserNameNode;
  FocusNode? _focusAvatarNameNode;
  TextEditingController? _userNameController;
  bool _registering = false;
  TextEditingController? _avatarNameController;
  String? selectAvatarType;
  String? selectStartTime;
  String? selectEndTime;
  String? userId;
  List<DropdownMenuItem<String>> dropdownAvatarTypes = dropdownMenuItems;
  List<DropdownMenuItem<String>> startTimes = dropdownTimes;
  List<DropdownMenuItem<String>> endTimes = dropdownTimes;

  //ページ起動時に呼ばれる初期化関数
  @override
  void initState() {
    super.initState();
    _focusUserNameNode = FocusNode();
    _focusAvatarNameNode = FocusNode();
    _userNameController =
        TextEditingController(text: ref.read(userDataProvider).userName);
    _avatarNameController =
        TextEditingController(text: ref.read(userDataProvider).avatarName);
    selectAvatarType = ref.read(userDataProvider).avatarType;
    List deskworkTime = ref.read(userDataProvider).deskworkTime;
    selectStartTime = deskworkTime[0];
    selectEndTime = deskworkTime[1];
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
                      const SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: const Color(0xff696969), width: 1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: DropdownButton(
                          style: const TextStyle(
                              fontSize: 25, color: Colors.black),
                          items: dropdownAvatarTypes,
                          value: selectAvatarType,
                          // =ref.read(userDataProvider).avatarType,
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
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(right: 10, top: 10),
                        child: const Text("デスクワーク時間",
                            style: TextStyle(
                                fontSize: 18, color: Color(0xff696969))),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: const Color(0xff696969), width: 1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: DropdownButton(
                              style: const TextStyle(
                                  fontSize: 25, color: Colors.black),
                              items: startTimes,
                              value: selectStartTime,
                              alignment: Alignment.center,
                              onChanged: (String? value) {
                                setState(() {
                                  selectStartTime = value!;
                                });
                              },
                              icon: const Icon(
                                Octicons.triangle_down,
                                size: 15,
                              ),
                              iconEnabledColor: const Color(0xff696969),
                              dropdownColor: Colors.white,
                              underline: Container(),
                            ),
                          ),
                          const SizedBox(width: 20),
                          const Text(
                            "〜",
                            style: TextStyle(fontSize: 20),
                          ),
                          const SizedBox(width: 20),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: const Color(0xff696969), width: 1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: DropdownButton(
                              style: const TextStyle(
                                  fontSize: 25, color: Colors.black),
                              items: endTimes,
                              value: selectEndTime,
                              alignment: Alignment.center,
                              onChanged: (String? value) {
                                setState(() {
                                  selectEndTime = value!;
                                });
                              },
                              icon: const Icon(
                                Octicons.triangle_down,
                                size: 15,
                              ),
                              iconEnabledColor: const Color(0xff696969),
                              dropdownColor: Colors.white,
                              underline: Container(),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                      TextButton(
                        onPressed: () async {
                          // firstNameとlastNameは必須で入力しないと登録できないようにする
                          if (_registering == false &&
                              _userNameController!.text != "" &&
                              _avatarNameController!.text != "") {
                            if (!context.mounted) return;
                            FocusScope.of(context).unfocus();
                            setState(() {
                              _registering = true;
                            });
                            await ref
                                .read(userDataProvider.notifier)
                                .changeProfile(
                                    ref.read(userDataProvider).userId!,
                                    _userNameController!.text,
                                    _avatarNameController!.text,
                                    selectAvatarType!,
                                    [selectStartTime, selectEndTime]);
                            navigateMain();
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
