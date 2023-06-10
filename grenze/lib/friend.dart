import "package:flutter/material.dart";
// import "package:fl_chart/fl_chart.dart";
// import "register.dart";
// import "package:device_info_plus/device_info_plus.dart";
import "package:shared_preferences/shared_preferences.dart";
import "main.dart";
import 'package:logger/logger.dart';

class FriendPage extends StatefulWidget {
  const FriendPage({Key? key}) : super(key: key);
  @override
  State<FriendPage> createState() => _FriendPageState();
}

class _FriendPageState extends State<FriendPage> {
  // _FriendPageState({Key? key}) : super(key: key);

  TextEditingController? _userIdController;
  var logger = Logger();

  @override
  void initState() {
    super.initState();
    _userIdController = TextEditingController(text: "aaa");
  }

  void changeUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("userId", _userIdController!.text);
    setState(() {
      userId = prefs.getString("userId");
    });
    logger.d(userId);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Scaffold(
          body: Center(
              child: Column(
        children: [
          TextField(
            autocorrect: false,
            autofocus: false,
            controller: _userIdController,
            decoration: InputDecoration(
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ),
              ),
              labelText: "userId",
              suffixIcon: IconButton(
                icon: const Icon(Icons.cancel),
                onPressed: () => _userIdController?.clear(),
              ),
            ),
            keyboardType: TextInputType.text,
            // readOnly: _registering,
            textCapitalization: TextCapitalization.none,
            textInputAction: TextInputAction.next,
          ),
          TextButton(
            onPressed: () {
              changeUserId();
            },
            child: const Text("Change userId"),
          ),
        ],
      ))),
    );
  }
}
