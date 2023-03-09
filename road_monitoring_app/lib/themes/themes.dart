import 'package:flutter/material.dart';
import 'package:road_monitoring_app/themes/constants.dart';

class Themes {
  static final darkTheme = ThemeData(
    fontFamily: 'Nunito',
    brightness: Brightness.dark,
    scaffoldBackgroundColor: bgColorDarkTheme,
    backgroundColor: bgColorDarkTheme,
    //cardColor: cardColorDarkTheme,
    //dialogBackgroundColor: dialogBgColorDarkTheme,
    iconTheme: const IconThemeData(
      color: iconColorDarkTheme,
    ),
  );
}
