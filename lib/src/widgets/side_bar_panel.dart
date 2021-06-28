import 'package:flutter/material.dart';

import './icon.dart';
import './helpers.dart';

class SideBarPanel extends StatelessWidget {
  final String title;
  final Widget child;
  final VoidCallback? onCancel;
  final PageStorageKey? scrollViewKey;
  final Key? onCloseKey;

  SideBarPanel({
    required this.title,
    required this.child,
    this.onCancel,
    this.scrollViewKey,
    this.onCloseKey,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).cardColor,
      width: sideBarSize(context),
      child: Stack(
        children: [
          Positioned.fill(
            child: SingleChildScrollView(
              key: scrollViewKey,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      title,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                    ),
                    SizedBox(height: 10),
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
