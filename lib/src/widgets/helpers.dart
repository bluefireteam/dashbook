import 'package:flutter/material.dart';

bool isLargeScreen(BuildContext context) =>
    MediaQuery.of(context).size.width > 768;

double iconSize(BuildContext context) => isLargeScreen(context) ? 24.0 : 48.0;

double sideBarSize(BuildContext context) {
  final screenWidth = MediaQuery.of(context).size.width;
  final factor = isLargeScreen(context) ? 0.5 : 1;
  return screenWidth * factor;
}
