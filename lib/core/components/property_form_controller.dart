import 'package:flutter/material.dart';

class PropertyFormController {
  final Map<String, TextEditingController> _controllers = {};

  TextEditingController getController(String key) {
    if (!_controllers.containsKey(key)) {
      _controllers[key] = TextEditingController();
    }
    return _controllers[key]!;
  }

  void dispose() {
    _controllers.forEach((key, controller) {
      controller.dispose();
    });

  }

  Map<String, String> getFormData() {
    final Map<String, String> formData = {};
    _controllers.forEach((key, controller) {
      formData[key] = controller.text;
    });
    return formData;
  }
}