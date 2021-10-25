import 'package:flutter/material.dart';

// ignore: one_member_abstracts
abstract class Decorator {
  Widget decorate(Widget child);
}

class CenterDecorator extends Decorator {
  @override
  Widget decorate(Widget child) => Center(child: child);
}
