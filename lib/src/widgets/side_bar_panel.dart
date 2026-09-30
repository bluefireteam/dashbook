import 'package:dashbook/src/device_size_extension.dart';
import 'package:dashbook/src/widgets/dashbook_icon.dart';
import 'package:material_ui/material_ui.dart';

class SideBarPanel extends StatelessWidget {
  const new({
    required this.title,
    required this.child,
    super.key,
    this.width,
    this.onCancel,
    this.scrollViewKey,
    this.onCloseKey,
    this.titleIcon,
    this.sideBarIsAlwaysShown = false,
  });

  final String title;
  final Widget child;
  final double? width;
  final VoidCallback? onCancel;
  final PageStorageKey<Object?>? scrollViewKey;
  final Key? onCloseKey;
  final DashbookIcon? titleIcon;
  final bool sideBarIsAlwaysShown;

  @override
  Widget build(BuildContext context) {
    final titleIcon = this.titleIcon;
    final showTitleIcon = context.isNotPhoneSize && !sideBarIsAlwaysShown;

    // A Material is needed here so that ListTile descendants paint their ink
    // splashes on top of this panel's background color rather than behind it.
    return Material(
      color: Theme.of(context).cardColor,
      child: SizedBox(
        width: width,
        child: Stack(
          children: [
            Positioned.fill(
              child: SingleChildScrollView(
                key: scrollViewKey,
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 16,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                          ),
                        ),
                        if (titleIcon != null && showTitleIcon) titleIcon,
                      ],
                    ),
                    const SizedBox(height: 10),
                    child,
                  ],
                ),
              ),
            ),
            if (!sideBarIsAlwaysShown)
              Positioned(
                right: 15,
                top: 15,
                child: DashbookIcon(
                  key: onCloseKey,
                  tooltip: 'Close',
                  icon: Icons.clear,
                  onPressed: onCancel,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
