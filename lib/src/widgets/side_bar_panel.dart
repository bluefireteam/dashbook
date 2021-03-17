import 'package:flutter/material.dart';

import './icon.dart';
import './helpers.dart';

class SideBarPanel extends StatelessWidget {
  final String title;
  final Widget child;
  final VoidCallback? onCancel;

  SideBarPanel({
    required this.title,
    required this.child,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final factor = isLargeScreen(context) ? 0.5 : 1;
    return Container(
      color: Theme.of(context).cardColor,
      width: screenWidth * factor,
      child: Stack(
        children: [
          Positioned.fill(
            child: SingleChildScrollView(
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
