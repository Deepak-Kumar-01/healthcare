import 'package:flutter/material.dart';
import 'foot_steps.dart';
import 'health_repository.dart';
class HomeController {
  final repository = HealthRepository();
  final steps = ValueNotifier(<FootSteps>[]);
  Future<void> getData() async {
    steps.value = await repository.getFootSteps();
  }
}