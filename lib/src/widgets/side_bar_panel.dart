import 'package:dashbook/src/widgets/icon.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SideBarPanel extends StatelessWidget {
  final String title;
  final Widget child;
  final VoidCallback? onCancel;
  final PageStorageKey? scrollViewKey;
  final Key? onCloseKey;
  final double width;
  final DashbookIcon? titleIcon;

  const SideBarPanel({
    Key? key,
    required this.title,
    required this.child,
    this.onCancel,
    this.scrollViewKey,
    this.onCloseKey,
    this.titleIcon,
    required this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                              left: 8,
                            ),
                            child: Opacity(
                              opacity: kIsWeb ? 1 : 0,
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
