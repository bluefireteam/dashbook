import 'package:device_frame/device_frame.dart';
import 'package:flutter/material.dart';

class DevicePreview extends StatelessWidget {
  final Widget child;
  final DeviceInfo deviceInfo;
  final Orientation deviceOrientation;
  final bool showDeviceFrame;

  const DevicePreview({
    Key? key,
    required this.child,
    required this.deviceInfo,
    required this.deviceOrientation,
    required this.showDeviceFrame,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = _mediaQueryData(context);

    return Padding(
      padding: EdgeInsets.only(
        top: 20 + mediaQuery.viewPadding.top,
        right: 20 + mediaQuery.viewPadding.right,
        left: 20 + mediaQuery.viewPadding.left,
        bottom: 20,
      ),
      child: FittedBox(
        child: DeviceFrame(
          orientation: deviceOrientation,
          device: deviceInfo,
          isFrameVisible: showDeviceFrame,
          screen: MediaQuery(
            data: mediaQuery,
            child: Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: child,
            ),
          ),
        ),
      ),
    );
  }

  MediaQueryData _mediaQueryData(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isRotated = DeviceFrame.isRotated(deviceInfo, deviceOrientation);

    final padding = isRotated
        ? (deviceInfo.rotatedSafeAreas ?? deviceInfo.safeAreas)
        : deviceInfo.safeAreas;

    final screenSize = deviceInfo.screenSize;
    final width = isRotated ? screenSize.height : screenSize.width;
    final height = isRotated ? screenSize.width : screenSize.height;

    return mediaQuery.copyWith(
      size: Size(width, height),
      padding: padding,
      viewInsets: EdgeInsets.zero,
      viewPadding: padding,
      devicePixelRatio: deviceInfo.pixelRatio,
    );
  }
}
