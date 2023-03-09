import 'package:flutter/material.dart';
import 'package:road_monitoring_app/screens/home_page.dart';
import 'package:road_monitoring_app/screens/login_page.dart';
import 'package:road_monitoring_app/screens/registration_page.dart';

class RouteGenerator {
  static Route<MaterialPageRoute> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (context) => const HomePage(),
        );
      case '/registration_page':
        return PageRouteBuilder(
          pageBuilder: (context, animation, secAnimation) {
            return const RegistrationPage();
          },
          transitionsBuilder: (context, animation, secAnimation, child) {
            return SlideTransition(
              position: animation.drive(_getTween(1.0, 0.0)),
              child: child,
            );
          },
        );
      case '/home_page':
        return PageRouteBuilder(
          pageBuilder: (context, animation, secAnimation) {
            return const HomePage();
          },
          transitionsBuilder: (context, animation, secAnimation, child) {
            return SlideTransition(
              position: animation.drive(_getTween(1.0, 0.0)),
              child: child,
            );
          },
        );
      default:
        return MaterialPageRoute(
          builder: (context) {
            return const Scaffold(
              body: Center(
                child: Text('ERROR'),
              ),
            );
          },
        );
    }
  }

  static Animatable<Offset> _getTween(double dx, double dy) {
    return Tween(
      begin: Offset(dx, dy),
      end: Offset.zero,
    ).chain(
      CurveTween(curve: Curves.ease),
    );
  }
}
