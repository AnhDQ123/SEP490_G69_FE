import 'responsive_utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextConstant {
  static TextStyle textStyleDefine(BuildContext context,
      {
       double size = 13,
       FontWeight fontWeight = FontWeight.w600,
       Color color = Colors.black}) {
    return GoogleFonts.montserrat(
        fontSize: UtilsReponsive.height(size, context),
        fontWeight: fontWeight,
        color: color);
  }

  static Text titleH1(BuildContext context,
      {required String text,
      double size = 28,
      FontWeight fontWeight = FontWeight.w900,
      Color color = Colors.black}) {
    return Text(
      text,
      style: textStyleDefine(context,
          size: size, fontWeight: fontWeight, color: color),
    );
  }

  static Text titleH2(BuildContext context,
      {required String text,
      double size = 22,
      FontWeight fontWeight = FontWeight.w800,
      Color color = Colors.black}) {
    return Text(
      text,
      style: textStyleDefine(context,
          size: size, fontWeight: fontWeight, color: color),
    );
  }

  static Text titleH3(BuildContext context,
      {required String text,
      double size = 16,
      FontWeight fontWeight = FontWeight.w700,
      Color color = Colors.black}) {
    return Text(
      text,
      style: textStyleDefine(context,
          size: size, fontWeight: fontWeight, color: color),
    );
  }

  static Text subTile1(BuildContext context,
      {required String text,
      double size = 16,
      FontWeight fontWeight = FontWeight.w600,
      Color color = Colors.black}) {
    return Text(
      text,
      style: textStyleDefine(context,
          size: size, fontWeight: fontWeight, color: color),
    );
  }

  static Text subTile2(BuildContext context,
      {required String text,
      double size = 14,
      FontWeight fontWeight = FontWeight.w600,
      Color color = Colors.black}) {
    return Text(
      text,
      style: textStyleDefine(context,
          size: size, fontWeight: fontWeight, color: color),
    );
  }

  static Text subTile3(BuildContext context,
      {required String text,
      double size = 11,
      TextAlign? textAlign,
      TextOverflow? overflow,
      FontWeight fontWeight = FontWeight.w600,
      Color color = Colors.black}) {
    return Text(
      text,
      textAlign: textAlign,
      overflow: overflow,
      style: textStyleDefine(context,
          size: size, fontWeight: fontWeight, color: color),
    );
  }
}
