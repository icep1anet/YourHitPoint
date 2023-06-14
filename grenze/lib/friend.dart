import "package:flutter/material.dart";
import "package:grenze/user_data.dart";
import "package:provider/provider.dart";
import "package:logger/logger.dart";
import "package:flutter/services.dart";
import "package:google_fonts/google_fonts.dart";



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
          appBar: AppBar(
            //オーバーレイが明るいカラースキームになります。
            systemOverlayStyle: SystemUiOverlayStyle.light,
            title: const Text("Friends"),
            centerTitle: true,
            // backgroundColor: Colors.grey,
          ),
          body: Center(
              child: Column(
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
          CardWidget(),















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

class CardWidget extends StatelessWidget {

  // final String _name;
  // final String _desc;
  // final String _picture;

  // CardWidget(this._name, this._desc, this._picture);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
            height: 200,
            // width: 800,
            child: Card(
                // color: Colors.green, // Card自体の色
                margin: const EdgeInsets.all(30),
                elevation: 8, // 影の離れ具合
                shadowColor: Colors.black ,// 影の色
                shape: RoundedRectangleBorder( // 枠線を変更できる
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Column(
                  mainAxisSize: MainAxisSize.max,
                  children:  [
                    ListTile(
                      leading: Icon(Icons.add),
                      title: Text('Card03'),
                      subtitle: Text('Card SubTitle'),
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