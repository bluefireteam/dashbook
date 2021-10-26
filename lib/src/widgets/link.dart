import 'package:flutter/material.dart';

class Link extends StatelessWidget {
  final String label;
  final TextStyle textStyle;
  final VoidCallback? onTap;
  final TextAlign textAlign;
  final EdgeInsets padding;

  const Link({
    Key? key,
    required this.label,
    required this.textStyle,
    required this.textAlign,
    this.onTap,
    this.padding = const EdgeInsets.all(10),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        padding: padding,
        child: Text(
          label,
          textAlign: textAlign,
          style: textStyle,
        ),
      ),
    );
  }
}
