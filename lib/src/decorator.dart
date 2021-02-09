import 'package:flutter/material.dart';

abstract class Decorator {
  Widget decorate(Widget child);
}

class CenterDecorator extends Decorator {
  @override
  Widget decorate(Widget child) => Center(child: child);
}
