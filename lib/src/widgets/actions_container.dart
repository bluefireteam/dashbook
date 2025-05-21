import 'package:dashbook/dashbook.dart';
import 'package:dashbook/src/widgets/helpers.dart';
import 'package:dashbook/src/widgets/keys.dart';
import 'package:dashbook/src/widgets/side_bar_panel.dart';
import 'package:flutter/material.dart';

class ActionsContainer extends StatelessWidget {
  const ActionsContainer({
    required this.onCancel,
    required this.currentChapter,
    super.key,
  });

  final VoidCallback onCancel;
  final Chapter currentChapter;

  @override
  Widget build(BuildContext context) {
    return SideBarPanel(
      title: 'Actions',
      onCloseKey: kActionsCloseIcon,
      width: sideBarSizeProperties(context),
      onCancel: onCancel,
      child: Column(
        children: [
          for (final MapEntry<String, void Function(BuildContext)> entry
              in currentChapter.ctx.actions.entries)
            Padding(
              padding: const EdgeInsets.all(8),
              child: ElevatedButton(
                onPressed: () => entry.value.call(context),
                child: Text(entry.key),
              ),
            ),
        ],
      ),
    );
  }
}
