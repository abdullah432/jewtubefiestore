import 'package:flutter/material.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<dynamic> navigateTo(String routeName, {Object arguments}) {
    if (arguments != null) {
      // routeName = Uri(path: routeName, queryParameters: queryParams).toString();
      return navigatorKey.currentState
          .pushNamed(routeName, arguments: arguments);
    }
    return navigatorKey.currentState.pushNamed(routeName);
  }

  Future<dynamic> navigateAndReplaceTo(String routeName, {Object arguments}) {
    if (arguments != null) {
      // routeName = Uri(path: routeName, arguments: arguments).toString();
      return navigatorKey.currentState.pushNamedAndRemoveUntil(
        routeName,
        (Route<dynamic> route) => false,
        arguments: arguments,
      );
    }
    return navigatorKey.currentState
        .pushNamedAndRemoveUntil(routeName, (Route<dynamic> route) => false);
  }

  void goBack() {
    return navigatorKey.currentState.pop();
  }
}
