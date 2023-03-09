import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'routes/route_generator.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(412.0, 915.0), // Samsung Galaxy S20 Ultra
      builder: (context, child) {
        return MaterialApp(
          title: 'Road Condition Monitoring',
          theme: ThemeData(fontFamily: 'Nunito'),
          initialRoute: '/',
          onGenerateRoute: RouteGenerator.generateRoute,
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}

// TODO:
/*
  1) Да се оправи layout-а на login page
  2) Да се премахнат ненужните контейнери
  3) Да се избере цветова тема
  4) Да се добави appBar с опция за връшане при registration page-a
  5) Да се промени текста на error съобщенията при невалидни данни. Да се види от нета какви са общоприетите съобщения.
  6) Да се оправи проблемът с чупенето, когато се появи клавиатурата при въвеждане на текст
  7) Да се override-не dispose()
  8) Да се направи функция, която да изнесе част от кода в route generator
*/