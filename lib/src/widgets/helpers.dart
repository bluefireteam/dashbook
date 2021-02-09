import 'package:flutter/material.dart';

bool isLargeScreen(BuildContext context) =>
    MediaQuery.of(context).size.width > 768;

double iconSize(BuildContext context) => isLargeScreen(context) ? 24.0 : 48.0;
