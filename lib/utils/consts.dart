import 'package:flutter/material.dart';

class Const {
  /* STRING */
  static const String appName = 'Factory Play';

  /* IMAGENES */
  static const String imgBackground = "assets/img/bg.jpg";
  static const String imgLogo = "assets/img/logo.png";

  /* ANIMATIONS */
  static const String aniClearCache = "assets/animation/clear_cache.json";
  static const String aniSplashLoading = "assets/animation/splash_loading.json";
  static const String aniLoading = "assets/animation/loading.json";

  /* COLORS */
  static const Color colorPurpleDarker = Color(0xFF141023);
  static const Color colorPurpleDark = Color(0xFF21243F);
  static const Color colorPurpleMediumDark = Color(0xFF2E395D);
  static const Color colorPurpleMedium = Color(0xFF42476F);
  static const Color colorPurpleLight = Color(0xFF664271);
  static const Color colorPurpleAccent = Color(0xFF8E4B7D);
  static const Color colorPinkAccent = Color(0xFFC55877);
  static const Color colorCoralAccent = Color(0xFFE68488);

  static const Color colorWhite = Colors.white;
  static const Color colorBlack = Colors.black;
  static const Color colorTransparent = Colors.transparent;
  static const Color colorWhiteTransparent = Color(0xB3FFFFFF);

  /* ICONS */
  static const IconData iconButomLogin = Icons.info_outline;

  /* FONTS */
  static const TextStyle fontHeaderH1TextStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: colorWhite,
  );
  static const TextStyle fontHeaderTextStyle = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: colorWhite,
  );
  static const TextStyle fontTitleTextStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: colorWhite,
  );
  static const TextStyle fontSubtitleTextStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: colorWhite,
  );
  static const TextStyle fontBodyTextStyle = TextStyle(
    fontSize: 16,
    color: colorWhite,
  );
  static const TextStyle fontCaptionTextStyle = TextStyle(
    fontSize: 14,
    color: colorWhite,
  );
  static const TextStyle fontSmallTextStyle = TextStyle(
    fontSize: 12,
    color: colorWhite,
  );

  /* RESPONSIVE */
  static const double sizeTablet = 950;

  Size getSize(BuildContext context) => MediaQuery.of(context).size;

  bool isTv(BuildContext context) {
    return MediaQuery.of(context).size.width > sizeTablet;
  }
}
