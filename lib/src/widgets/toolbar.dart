import 'package:dashbook/dashbook.dart';
import 'package:dashbook/src/platform_utils/platform_utils.dart';
import 'package:dashbook/src/widgets/dashbook_icon.dart';
import 'package:dashbook/src/widgets/helpers.dart';
import 'package:dashbook/src/widgets/instructions_dialog.dart';
import 'package:dashbook/src/widgets/keys.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

class Toolbar extends StatelessWidget {
  const new({
    required this.chapter,
    required this.onOpenProperties,
    required this.onOpenActions,
    required this.onOpenDeviceSettings,
    this.themeIcon,
    super.key,
  });

  final Chapter? chapter;
  final VoidCallback onOpenProperties;
  final VoidCallback onOpenActions;
  final VoidCallback onOpenDeviceSettings;
  final Widget? themeIcon;

  @override
  Widget build(BuildContext context) {
    final chapter = this.chapter;

    return Align(
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        primary: false,
        padding: const EdgeInsets.only(top: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (chapter != null && chapter.ctx.properties.isNotEmpty)
              DashbookIcon(
                key: kPropertiesIcon,
                tooltip: 'Properties panel',
                icon: Icons.mode_edit,
                onPressed: onOpenProperties,
              ),
            if (chapter != null && chapter.ctx.actions.isNotEmpty)
              DashbookIcon(
                key: kActionsIcon,
                tooltip: 'Actions panel',
                icon: Icons.play_arrow,
                onPressed: onOpenActions,
              ),
            if (chapter case Chapter(:final info?, pinInfo: false))
              _InstructionsIcon(instructions: info),
            if (chapter?.codeLink case final codeLink?)
              _CodeLinkIcon(codeLink: codeLink),
            ?themeIcon,
            if (kIsWeb && chapter != null) _ShareIcon(chapter: chapter),
            DashbookIcon(
              key: kDevicePreviewIcon,
              tooltip: 'Device preview',
              icon: Icons.phone_android_outlined,
              onPressed: onOpenDeviceSettings,
            ),
          ],
        ),
      ),
    );
  }
}

class _InstructionsIcon extends StatelessWidget {
  const new({required this.instructions});

  final String instructions;

  @override
  Widget build(BuildContext context) {
    return DashbookIcon(
      tooltip: 'Instructions',
      icon: Icons.info,
      onPressed: () => showPopup<void>(
        context: context,
        builder: (_) => InstructionsDialog(instructions: instructions),
      ),
    );
  }
}

class _CodeLinkIcon extends StatelessWidget {
  const new({required this.codeLink});

  final String codeLink;

  Future<void> _launch(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final uri = Uri.tryParse(codeLink);

    if (uri != null && await url_launcher.canLaunchUrl(uri)) {
      await url_launcher.launchUrl(uri);
    } else {
      messenger.showSnackBar(
        SnackBar(content: Text('Could not launch $codeLink')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DashbookIcon(
      tooltip: 'See code',
      icon: Icons.code,
      onPressed: () => _launch(context),
    );
  }
}

class _ShareIcon extends StatelessWidget {
  const new({required this.chapter});

  final Chapter chapter;

  Future<void> _share(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    await Clipboard.setData(ClipboardData(text: getChapterUrl(chapter)));
    messenger.showSnackBar(
      const SnackBar(content: Text('Link copied to your clipboard')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DashbookIcon(
      tooltip: 'Share this example',
      icon: Icons.share,
      onPressed: () => _share(context),
    );
  }
}
