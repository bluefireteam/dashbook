import 'package:material_ui/material_ui.dart';

enum MessageCardType { info, error }

/// Naive widget to be an example of a little bit more
/// complex one with different types.
class MessageCard extends StatelessWidget {
  const new({
    required this.message,
    required this.type,
    super.key,
    this.errorColor = const Color(0xFFCC6941),
    this.infoColor = const Color(0xFF5E89FF),
  });

  final String message;
  final MessageCardType type;

  final Color errorColor;
  final Color infoColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      color: type == MessageCardType.info ? infoColor : errorColor,
      child: Text(message),
    );
  }
}
