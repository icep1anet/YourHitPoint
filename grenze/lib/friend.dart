import "package:flutter/material.dart";
import "package:grenze/user_data.dart";
import "package:provider/provider.dart";
import "package:logger/logger.dart";
import "package:flutter/services.dart";
import "package:google_fonts/google_fonts.dart";

var logger = Logger();

class FriendPage extends StatefulWidget {
  const FriendPage({Key? key}) : super(key: key);
  @override
  State<FriendPage> createState() => _FriendPageState();
}

class _FriendPageState extends State<FriendPage> {
  Color hpFontColor = Colors.black;

  @override
  Widget build(BuildContext context) {
    final UserDataProvider userDataProvider =
        Provider.of<UserDataProvider>(context, listen: true);
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
      body: Center(
        child: SizedBox(
          child: Column(
            children: [
              const SizedBox(height: 30),
              Expanded(
                child: ListView.builder(
                  // shrinkWrap: true,
                  itemCount: userDataProvider.friendDataList.length,
                  itemBuilder: (BuildContext context, int index) {
                    Map friendData = userDataProvider.friendDataList[index];
                    //各フレンドのHPによって表示の色が変わるようにする
                    int friendHP = friendData["currentHP"].toInt();
                    if (80 < friendHP) {
                      hpFontColor = const Color(0xFF32cd32);
                    } else if (30 < friendHP && friendHP <= 80) {
                      hpFontColor = const Color(0xff00ff7f);
                    } else if (0 < friendHP && friendHP <= 30) {
                      hpFontColor = const Color(0xffffd700);
                    } else {
                      hpFontColor = const Color(0xffdc143c);
                    }
                    return FriendCardWidget(friendHP,
                        friendData["friendName"],
                        friendData["avatarUrl"],
                        hpFontColor);
                  },
                ),
              ),
              const ChangeIdWidget(),
            ],
          ),
        ),
      ),
    );
  }
}

class ChangeIdWidget extends StatefulWidget {
  const ChangeIdWidget({Key? key}) : super(key: key);

  @override
  State<ChangeIdWidget> createState() => _ChangeIdWidgetState();
}

class _ChangeIdWidgetState extends State<ChangeIdWidget> {
  TextEditingController? _userIdController;

  @override
  void initState() {
    super.initState();
    _userIdController = TextEditingController(text: "id_abcd");
  }

  @override
  void dispose() {
    _userIdController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
        onPressed: () {
          context.read<UserDataProvider>().setUserId(_userIdController!.text);
        },
        child: const Text("Change userId"),
      )
    ]);
  }
}

class FriendCardWidget extends StatelessWidget {
  final int currentHP;
  final String friendName;
  final String avatarUrl;
  final Color hpFontColor;

  const FriendCardWidget(this.currentHP, this.friendName, this.avatarUrl,this.hpFontColor,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 15.0),
      decoration: BoxDecoration(
        color: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              spreadRadius: 1,
              blurRadius: 10,
              offset: Offset(5, 5)
            )
          ],
          border: Border.all(color: const Color(0xFFE0E0E0)),
          borderRadius: BorderRadius.circular(8.0)),
      padding: const EdgeInsets.all(5),
      child: Row(
        children: [
          const SizedBox(
            width: 20,
          ),
          Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(friendName,
                  style: GoogleFonts.roboto(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: Colors.black)
                  // style: const TextStyle(fontWeight: FontWeight.bold),
                  // maxLines: 2,
                  // overflow: TextOverflow.ellipsis,
                  ),
              const SizedBox(height: 12),
              Text(" HP: $currentHP",
                  textAlign: TextAlign.left,
                  style: GoogleFonts.roboto(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: hpFontColor)),
              const SizedBox(height: 8),
            ],
          )),
          
          Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  // color: Colors.grey,
                  // border: Border.all(color: Colors.grey ),
                  // borderRadius: BorderRadius.circular(8.0),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(avatarUrl),
                  ))),
                  const SizedBox(width: 20,),
        ],
      ),
    );
  }
}



    //card
    //     return SizedBox(
    //   height: 200,
    //   // width: 800,
    //   child: Card(
    //     color: const Color(0xffe0ffff), // Card自体の色
    //     margin: const EdgeInsets.only(left: 30, right: 30, top: 20, bottom: 20),
    //     elevation: 8, // 影の離れ具合
    //     shadowColor: Colors.black, // 影の色
    //     shape: RoundedRectangleBorder(
    //       // 枠線を変更できる
    //       borderRadius: BorderRadius.circular(10),
    //     ),
    //     child: Column(
    //       mainAxisSize: MainAxisSize.max,
    //       children: [
    //         ListTile(
    //           leading: _currentmyAvatar(avatarUrl),
    //           title: Text(friendName),
    //           subtitle: Text(currentHP.toString()),
    //         ),
    //         // Text('hello'),
    //       ],
    //     ),
    //   ),
    // );