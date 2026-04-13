// ignore_for_file: file_names
part of '../header.dart';

class TextStyling {
  defaultWhite(double size) => TextStyle(color: defWhite, fontSize: size);
  defaultWhiteBold(double size) => TextStyle(color: defWhite, fontWeight: FontWeight.bold, fontSize: size);
  defaultBlack(double size) => TextStyle(color: defBlack1, fontSize: size);
  defaultBlackBold(double size) => TextStyle(color: defBlack1, fontSize: size, fontWeight: FontWeight.bold);
  customColor(double size, Color color) => TextStyle(color: color, fontSize: size);
  customColorBold(double size, Color color) => TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: size);

  TextStyle linearDisplay(double size, {Color? color}) => TextStyle(
        color: color ?? linearTextPrimary,
        fontSize: size,
        fontFamily: "Nunito",
        fontWeight: FontWeight.w600,
        height: 1.05,
        letterSpacing: size >= 64
            ? -1.4
            : size >= 48
                ? -1.05
                : size >= 32
                    ? -0.7
                    : -0.24,
      );

  TextStyle linearTitle(double size, {Color? color, bool strong = false}) => TextStyle(
        color: color ?? linearTextPrimary,
        fontSize: size,
        fontFamily: "Nunito",
        fontWeight: strong ? FontWeight.w700 : FontWeight.w600,
        height: 1.2,
        letterSpacing: size >= 20 ? -0.24 : -0.13,
      );

  TextStyle linearBody(
    double size, {
    Color? color,
    bool emphasis = false,
    double height = 1.5,
  }) =>
      TextStyle(
        color: color ?? linearTextSecondary,
        fontSize: size,
        fontFamily: "Lato",
        fontWeight: emphasis ? FontWeight.w600 : FontWeight.w400,
        height: height,
        letterSpacing: size >= 18 ? -0.16 : 0,
      );

  TextStyle linearCaption(
    double size, {
    Color? color,
    bool emphasis = false,
  }) =>
      TextStyle(
        color: color ?? linearTextTertiary,
        fontSize: size,
        fontFamily: "Lato",
        fontWeight: emphasis ? FontWeight.w600 : FontWeight.w500,
        height: 1.4,
        letterSpacing: -0.12,
      );

  TextStyle linearMono(double size, {Color? color}) => TextStyle(
        color: color ?? linearTextTertiary,
        fontSize: size,
        fontFamily: "Lato",
        letterSpacing: 0.2,
      );

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
