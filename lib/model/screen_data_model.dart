import 'package:flutter/animation.dart';
import 'enum.dart';

class ScreenDataModel {
  final Color color;
  final ScreenType type;
  final String main;
  final String? body;
  final bool showSkip;

  ScreenDataModel({
    required this.color,
    required this.type,
    required this.main,
    this.body,
    this.showSkip = false,
  });
}
