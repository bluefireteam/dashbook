import 'package:flutter/material.dart';

class Link extends StatelessWidget {
  final String label;
  final TextStyle textStyle;
  final VoidCallback? onTap;
  final TextAlign textAlign;
  final EdgeInsets padding;
  final double height;

  Link({
    required this.label,
    required this.textStyle,
    required this.textAlign,
    this.onTap,
    this.padding = const EdgeInsets.all(10),
    this.height = 40,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: height,
        padding: padding,
        child: Text(
          this.label,
          textAlign: textAlign,
          style: textStyle,
        ),
      ),
      onTap: onTap,
    );
  }
}
