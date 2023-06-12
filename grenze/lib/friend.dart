import "package:flutter/material.dart";
import "package:grenze/user_data.dart";
import "package:provider/provider.dart";
import "package:logger/logger.dart";

class FriendPage extends StatefulWidget {
  const FriendPage({Key? key}) : super(key: key);
  @override
  State<FriendPage> createState() => _FriendPageState();
}

class _FriendPageState extends State<FriendPage> {
  TextEditingController? _userIdController;
  var logger = Logger();

  @override
  void initState() {
    super.initState();
    _userIdController = TextEditingController(text: "your id");
  }

  @override
  void dispose() {
    _userIdController?.dispose();
    super.dispose();
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
              context.read<UserDataProvider>().setUserId(_userIdController!.text);
            },
            child: const Text("Change userId"),
          ),
        ],
      ))),
    );
  }
}
