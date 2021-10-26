import 'package:dashbook/src/widgets/device_preview.dart';
import 'package:dashbook/src/widgets/helpers.dart';
import 'package:device_frame/device_frame.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PreviewContainer extends StatelessWidget {
  final bool usePreviewSafeArea;
  final Widget child;
  final bool isPropertiesOpen;
  final DeviceInfo? deviceInfo;
  final Orientation? deviceOrientation;
  final bool showDeviceFrame;

  const PreviewContainer({
    required Key key,
    required this.child,
    required this.usePreviewSafeArea,
    required this.isPropertiesOpen,
    required this.showDeviceFrame,
    this.deviceInfo,
    this.deviceOrientation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      bottom: 0,
      left: 0,
      right: (kIsWeb && isPropertiesOpen) ? sideBarSizeProperties(context) : 0,
      child: deviceInfo != null
          ? DevicePreview(
              showDeviceFrame: showDeviceFrame,
              deviceInfo: deviceInfo!,
              deviceOrientation: deviceOrientation!,
              child: Container(
                decoration: BoxDecoration(
                  border: usePreviewSafeArea
                      ? Border(
                          left: BorderSide(
                            color: Theme.of(context).cardColor,
                            width: iconSize(context) * 2,
                          ),
                          right: BorderSide(
                            color: Theme.of(context).cardColor,
                            width: iconSize(context) * 2,
                          ),
                        )
                      : null,
                ),
                child: child,
              ),
            )
          : child,
    );
  }
}
