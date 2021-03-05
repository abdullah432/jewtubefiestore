import 'package:flutter/material.dart';
import 'package:jewtubefirestore/screens/auth/signin.dart';
import 'package:jewtubefirestore/screens/auth/signup.dart';
import 'package:jewtubefirestore/screens/bottomnavbar/bottomnavigationbar.dart';
import 'routing_names.dart';
import '../extensions/string_extension.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  var routingData = settings.name.getRoutingData;
  print('routingData: ' + routingData.route.toString());

  switch (routingData.route) {
    case LoginRoute:
      return _getPageRoute(SignInPage(), settings);
    case SignupRoute:
      return _getPageRoute(SignUpScreen(), settings);
    case MyBottomNavBarRoute:
      return _getPageRoute(
          MyBottomNavBarPage(
            selectedIndex: settings?.arguments ?? 0,
          ),
          settings);

    default:
      return _getPageRoute(SignInPage(), settings);
  }
}

navigateToPageWithReplacement(Widget child, settings) {
  return MaterialPageRoute(builder: (context) => child, settings: settings);
}

PageRoute _getPageRoute(Widget child, RouteSettings settings) {
  return _FadeRoute(child: child, routeName: settings.name);
}

class _FadeRoute extends PageRouteBuilder {
  final Widget child;
  final String routeName;
  _FadeRoute({
    this.child,
    this.routeName,
  }) : super(
          settings: RouteSettings(name: routeName),
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              child,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
}
