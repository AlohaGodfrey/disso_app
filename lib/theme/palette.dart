import 'package:flutter/material.dart';

//global app theme
class Palette {
  static const deviceScreenThreshold = 650;
  static const MaterialColor kToDark = MaterialColor(
    0xffa7cdcc, // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
    <int, Color>{
      50: Color(0xff96b9b8), //10%
      100: Color(0xff86a4a3), //20%
      200: Color(0xff75908f), //30%
      300: Color(0xff647b7a), //40%
      400: Color(0xff546766), //50%
      500: Color(0xff435252), //60%
      600: Color(0xff323d3d), //70%
      700: Color(0xff212929), //80%
      800: Color(0xff111414), //90%
      900: Color(0xff000000), //100%
    },
  );

  static const MaterialColor kToLight = MaterialColor(
    0xffa7cdcc, // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
    <int, Color>{
      50: Color(0xffb0d2d1), //10%
      100: Color(0xffb9d7d6), //20%
      200: Color(0xffc1dcdb), //30%
      300: Color(0xffcae1e0), //40%
      400: Color(0xffd3e6e6), //50%
      500: Color(0xffdcebeb), //60%
      600: Color(0xffe5f0f0), //70%
      700: Color(0xffedf5f5), //80%
      800: Color(0xfff6fafa), //90%
      900: Color(0xffffffff), //100%
    },
  );

  static const MaterialColor bToDark = MaterialColor(
    0xff014a55,
    <int, Color>{
      50: Color(0xff01434d), //10%
      100: Color(0xff013b44), //20%
      200: Color(0xff01343b), //30%
      300: Color(0xff012c33), //40%
      400: Color(0xff01252b), //50%
      500: Color(0xff001e22), //60%
      600: Color(0xff001619), //70%
      700: Color(0xff000f11), //80%
      800: Color(0xff000708), //90%
      900: Color(0xffffffff), //100%
    },
  );

  static const MaterialColor bToLight = MaterialColor(
    0xff014a55,
    <int, Color>{
      50: Color(0xff1a5c66), //10%
      100: Color(0xff346e77), //20%
      200: Color(0xff4d8088), //30%
      300: Color(0xff679299), //40%
      400: Color(0xff80a5aa), //50%
      500: Color(0xff99b7bb), //60%
      600: Color(0xffb3c9cc), //70%
      700: Color(0xffccdbdd), //80%
      800: Color(0xffe6edee), //90%
      900: Color(0xffffffff), //100%
    },
  );
} // you can define define int 500 as the default shade and add your lighter tints above and darker tints below.

ThemeData paletteThemeData() {
  return ThemeData(
    //uses custom theme pallete
    primarySwatch: Palette.kToDark,
    canvasColor: const Color.fromRGBO(246, 246, 246, 1),
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 24,
        fontFamily: 'Lato',
      ),
    ),
    textTheme: ThemeData.light().textTheme.copyWith(
          headline6: const TextStyle(
            fontSize: 24,
            fontFamily: 'Anton',
          ),
        ),
  );
}
