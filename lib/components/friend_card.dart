import 'package:flutter/material.dart';
import "package:google_fonts/google_fonts.dart";

class FriendCardWidget extends StatelessWidget {
  final int currentHP;
  final String friendName;
  final String avatarUrl;
  final Color hpFontColor;

  const FriendCardWidget(
      this.currentHP, this.friendName, this.avatarUrl, this.hpFontColor,
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
                blurRadius: 3,
                offset: Offset(3, 3))
          ],
          border: Border.all(color: const Color(0xFFE0E0E0)),
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8.0),
              topRight: Radius.circular(54.0),
              bottomLeft: Radius.circular(8.0),
              bottomRight: Radius.circular(8.0))),
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
                      color: Colors.black)),
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
                  border: Border.all(color: hpFontColor, width: 2),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(avatarUrl),
                  ))),
          const SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }
}
