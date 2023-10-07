import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";


class Utils{

  Widget currentmyAvatar(BuildContext context, String? imgUrl, double radius) {
    var color = const Color(0xffd9d9d9);
    final hasImage = imgUrl != null;
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(width: 5, color: Theme.of(context).focusColor),
      ),
      child: CircleAvatar(
        backgroundColor: hasImage ? Colors.transparent : color,
        backgroundImage: hasImage ? NetworkImage(imgUrl) : null,
        radius: radius,
        child: !hasImage
            ? Text("No image",
                // style: GoogleFonts.orelegaOne(
                style: GoogleFonts.roboto(
                  color: const Color(0xff1e90ff),
                  fontWeight: FontWeight.bold,
                  fontSize: radius*26.0/100.0,
                  // fontSize: 26,
                ))
            : null,
      ),
    );
  }

}