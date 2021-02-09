import 'package:flutter/material.dart';

class Link extends StatelessWidget {
  final String label;
  final TextStyle textStyle;
  final void Function() onTap;
  final TextAlign textAlign;
  final EdgeInsets padding;
  final double height;

  Link({
    this.label,
    this.onTap,
    this.textStyle,
    this.textAlign,
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
