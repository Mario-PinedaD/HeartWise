import 'package:flutter/material.dart';

class BiomarkersController {
  final Map<String, TextEditingController> controllers = {};

  void init(List<String> ids) {
    for (final id in ids) {
      controllers[id] = TextEditingController();
    }
  }

  void dispose() {
    for (final c in controllers.values) {
      c.dispose();
    }
  }
}
