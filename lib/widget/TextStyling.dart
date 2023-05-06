// ignore_for_file: file_names
part of '../header.dart';

class TextStyling {
  defaultWhite(double size) => TextStyle(color: defWhite, fontSize: size);
  defaultWhiteBold(double size) => TextStyle(color: defWhite, fontWeight: FontWeight.bold, fontSize: size);
  defaultBlack(double size) => TextStyle(color: defBlack1, fontSize: size);
  defaultBlackBold(double size) => TextStyle(color: defBlack1, fontSize: size, fontWeight: FontWeight.bold);
  customColor(double size, Color color) => TextStyle(color: color, fontSize: size);
  customColorBold(double size, Color color) => TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: size);

  //McLaren
  mcLarenBold(double size, Color color) => TextStyle(
        color: color,
        fontWeight: FontWeight.bold,
        fontSize: size,
        fontFamily: "Mclaren",
      );

  mcLaren(double size, Color color) => TextStyle(
        color: color,
        fontSize: size,
        fontFamily: "Mclaren",
      );

  //Nunito
  nunitoBold(double size, Color color) => TextStyle(
        color: color,
        fontWeight: FontWeight.bold,
        fontSize: size,
        fontFamily: "Nunito",
      );

  nuniton(double size, Color color) => TextStyle(
        color: color,
        fontSize: size,
        fontFamily: "Nunito",
      );
}
