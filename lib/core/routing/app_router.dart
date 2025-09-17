import 'package:flutter/material.dart';

class AppRouter {
  static Future<T?> push<T>(BuildContext context, Widget page) {
    return Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => page),
    );
  }

  static Future<T?> replace<T>(BuildContext context, Widget page) {
    return Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => page),
    );
  }

  static Future<T?> clearAndGo<T>(BuildContext context, Widget page) {
    return Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => page),
      (route) => false,
    );
  }
}
