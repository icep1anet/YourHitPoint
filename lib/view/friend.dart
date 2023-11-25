import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:logger/logger.dart";
import "package:flutter/services.dart";
import "package:google_fonts/google_fonts.dart";
import "package:your_hit_point/view_model/HP_notifier.dart";
import "package:your_hit_point/view_model/friend_data_notifier.dart";

import "package:your_hit_point/view_model/user_data_notifier.dart";

var logger = Logger();

class FriendPage extends ConsumerStatefulWidget {
  const FriendPage({Key? key}) : super(key: key);
  @override
  FriendPageState createState() => FriendPageState();
}

class FriendPageState extends ConsumerState<FriendPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(friendDataProvider.notifier).fetchFriendData();
    });
    logger.d("friend");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 105,
        //オーバーレイが明るいカラースキームになります。
        systemOverlayStyle: SystemUiOverlayStyle.light,
        title: Text(
          "Friends hit point",
          style: GoogleFonts.bebasNeue(
              textStyle: Theme.of(context).textTheme.headlineMedium,
              fontSize: 50,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).cardColor),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xff00a5bf),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(friendDataProvider.notifier).fetchFriendData();
        },
        child: Center(
          child: SizedBox(
            child: Column(
              children: [
                const SizedBox(height: 30),
                Expanded(
                  child: ListView.builder(
                    // shrinkWrap: true,
                    itemCount: ref.watch(friendDataProvider).length,
                    itemBuilder: (BuildContext context, int index) {
                      return ref
                          .watch(friendDataProvider.notifier)
                          .createFriendCardWidget(index);
                    },
                  ),
                ),
                // const ChangeIdWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ChangeIdWidget extends ConsumerStatefulWidget {
  const ChangeIdWidget({Key? key}) : super(key: key);

  @override
  ChangeIdWidgetState createState() => ChangeIdWidgetState();
}

class ChangeIdWidgetState extends ConsumerState<ChangeIdWidget> {
  TextEditingController? _userIdController;

  @override
  void initState() {
    super.initState();
    // idを変更することで別の人のデータを取り出せる
    _userIdController = TextEditingController(text: "id_abcd");
  }

  @override
  void dispose() {
    _userIdController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        padding: const EdgeInsets.all(10),
        child: TextField(
          autocorrect: false,
          autofocus: false,
          controller: _userIdController,
          decoration: InputDecoration(
            // contentPadding: const EdgeInsets.all(5),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(8),
              ),
            ),
            labelText: "userId",
            labelStyle: const TextStyle(fontSize: 25),
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
      ),
      TextButton(
        onPressed: () async {
          await ref
              .read(userDataProvider.notifier)
              .refreshUserID(_userIdController!.text);
          await ref.read(hpProvider.notifier).requestHP(ref);
        },
        child: const Text("Change userId"),
      )
    ]);
  }
}
