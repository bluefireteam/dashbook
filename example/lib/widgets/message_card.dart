import 'package:flutter/material.dart';

enum MessageCardType {
  info,
  error,
}

/// Naive widget to be an example of a little bit more
/// complex one with different types.
class MessageCard extends StatelessWidget {
  final String message;
  final MessageCardType type;

  final Color errorColor;
  final Color infoColor;

  const MessageCard({
    Key? key,
    required this.message,
    required this.type,
    this.errorColor = const Color(0xFFCC6941),
    this.infoColor = const Color(0xFF5E89FF),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      color: type == MessageCardType.info ? infoColor : errorColor,
      child: Text(message),
    );
  }
}
