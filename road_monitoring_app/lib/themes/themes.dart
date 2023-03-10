import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:road_monitoring_app/themes/constants.dart';

class Themes {
  static final darkTheme = ThemeData(
    fontFamily: 'Nunito',
    brightness: Brightness.dark,
    scaffoldBackgroundColor: bgColorDarkTheme,
    backgroundColor: bgColorDarkTheme,
    //cardColor: cardColorDarkTheme,
    //dialogBackgroundColor: dialogBgColorDarkTheme,
    appBarTheme: AppBarTheme(
      toolbarHeight: 74.0.h,
      elevation: 0.0,
      backgroundColor: bgColorDarkTheme,
      shape: const Border(
        bottom: BorderSide(
          color: borderColorDarkTheme,
          width: 1.5,
        ),
      ),
    ),
    iconTheme: const IconThemeData(
      color: iconColorDarkTheme,
    ),
  );
}
