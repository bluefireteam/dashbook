import 'package:dashbook/src/device_size_extension.dart';
import 'package:dashbook/src/widgets/dashbook_icon.dart';
import 'package:flutter/material.dart';

class SideBarPanel extends StatelessWidget {
  final String title;
  final Widget child;
  final VoidCallback? onCancel;
  final PageStorageKey<Object?>? scrollViewKey;
  final Key? onCloseKey;
  final double width;
  final DashbookIcon? titleIcon;
  final bool sideBarIsAlwaysShown;

  const SideBarPanel({
    required this.title,
    required this.child,
    required this.width,
    super.key,
    this.onCancel,
    this.scrollViewKey,
    this.onCloseKey,
    this.titleIcon,
    this.sideBarIsAlwaysShown = false,
  });

  @override
  Widget build(BuildContext context) {
    final showTitleIcon = context.isNotPhoneSize && !sideBarIsAlwaysShown;

    return Container(
      color: Theme.of(context).cardColor,
      width: width,
      child: Stack(
        children: [
          Positioned.fill(
            child: SingleChildScrollView(
              key: scrollViewKey,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                          ),
                        ),
                        if (titleIcon != null)
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 16,
                            ),
                            child: Opacity(
                              opacity: showTitleIcon ? 1 : 0,
                              child: titleIcon,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    child,
                  ],
                ),
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
                onClick: () => onCancel?.call(),
              ),
            ),
        ],
      ),
    );
  }
}
