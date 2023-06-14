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
  @override
  Widget build(BuildContext context) {
    final UserDataProvider userDataProvider =
        Provider.of<UserDataProvider>(context, listen: true);
    return
      // padding: const EdgeInsets.all(20),
      Scaffold(
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
            child: Column(
              children: [
                const SizedBox(height: 400),
                // const ChangeIdWidget(),
                Column(
                  children: [
                      // SizedBox(
                      //   height: 200,
                      //   // width: 800,
                      //   child: Card(
                      //       // color: Colors.green, // Card自体の色
                      //       margin: const EdgeInsets.all(30),
                      //       elevation: 8, // 影の離れ具合
                      //       shadowColor: Colors.black ,// 影の色
                      //       shape: RoundedRectangleBorder( // 枠線を変更できる
                      //         borderRadius: BorderRadius.circular(10),
                      //       ),
                      //       child: const Column(
                      //         mainAxisSize: MainAxisSize.max,
                      //         children:  [
                      //           ListTile(
                      //             leading: Icon(Icons.add),
                      //             title: Text('Card03'),
                      //             subtitle: Text('Card SubTitle'),
                      //           ),
                      //           // Text('hello'),
                      //         ],
                      //       ),
                      //     ),
                      // ),
                      // const Divider(),
                      // ListView.builder(
                      // itemCount: userDataProvider.friendDataList.length,
                      // itemBuilder: (BuildContext context, int index) {
                      //   Map friendData = userDataProvider.friendDataList[index];
                      //   return CardWidget(friendData["currentHP"], friendData["friendName"], friendData["avatarUrl"]);
                      // },),
                      // const Divider(),
                      ListView.builder(
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              height: 136,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8.0),
                              decoration: BoxDecoration(
                                  border: Border.all(color: const Color(0xFFE0E0E0)),
                                  borderRadius: BorderRadius.circular(8.0)),
                              padding: const EdgeInsets.all(8),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "id_toko",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 8),
                                      Text("こんにちは",
                                          style: Theme.of(context).textTheme.caption),
                                      const SizedBox(height: 8),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icons.bookmark_border_rounded,
                                          Icons.share,
                                          Icons.more_vert
                                        ].map((e) {
                                          return InkWell(
                                            onTap: () {},
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.only(right: 8.0),
                                              child: Icon(e, size: 16),
                                            ),
                                          );
                                        }).toList(),
                                      )
                                    ],
                                  )),
                                  Container(
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(
                                          color: Colors.grey,
                                          borderRadius: BorderRadius.circular(8.0),
                                          // image: DecorationImage(
                                          //   fit: BoxFit.cover,
                                          //   // image: NetworkImage(),
                                          // )
                                          )),
                                ],
                              ),
                            );
                          },
                        ),
                  ],
                ),
              ]
          )   
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
    _userIdController = TextEditingController(text: "your id");
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
        TextField(
          // scrollPadding: EdgeInsets.all(10),
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
        TextButton(
          onPressed: () {
            context
                .read<UserDataProvider>()
                .setUserId(_userIdController!.text);
          },
          child: const Text("Change userId"),
        )]
      );
  }
}

class CardWidget extends StatelessWidget {
  final int currentHP;
  final String friendName;
  final String avatarUrl;

  const CardWidget(this.currentHP, this.friendName, this.avatarUrl, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      // width: 800,
      child: Card(
        color: const Color(0xffe0ffff), // Card自体の色
        margin: const EdgeInsets.only(left: 30, right: 30, top: 20, bottom: 20),
        elevation: 8, // 影の離れ具合
        shadowColor: Colors.black, // 影の色
        shape: RoundedRectangleBorder(
          // 枠線を変更できる
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            ListTile(
              leading: _currentmyAvatar(avatarUrl),
              title: Text(friendName),
              subtitle: Text(currentHP.toString()),
            ),
            // Text('hello'),
          ],
        ),
      ),
    );
  }

  Widget _currentmyAvatar(String? imgUrl) {
    var color = const Color(0xffd9d9d9);
    final hasImage = imgUrl != null;
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        // border: Border.all(width: 5, color: Theme.of(context).focusColor),
      ),
      child: CircleAvatar(
        backgroundColor: hasImage ? Colors.transparent : color,
        backgroundImage: hasImage ? NetworkImage(imgUrl) : null,
        radius: 100,
        child: !hasImage
            ? Text("No image",
                // style: GoogleFonts.orelegaOne(
                style: GoogleFonts.roboto(
                  color: const Color(0xff1e90ff),
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ))
            : null,
      ),
    );
  }
}


    // return Card(
    //   child: Column(
    //     mainAxisSize: MainAxisSize.max,
    //     children: <Widget>[
    //       ListTile(
    //         leading: _currentmyAvatar(null),
    //         title: const Text("Name"),
    //         subtitle: const Text("subtitle"),
    //       ),


    //     ],
    //   ),
    // );