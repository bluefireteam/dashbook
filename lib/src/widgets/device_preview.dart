import 'package:device_frame/device_frame.dart';
import 'package:flutter/material.dart';

class DevicePreview extends StatelessWidget {
  final Widget child;
  final DeviceInfo deviceInfo;

  const DevicePreview({
    Key? key,
    required this.child,
    required this.deviceInfo,
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
        fit: BoxFit.contain,
        child: DeviceFrame(
          device: deviceInfo,
          isFrameVisible: true,
          screen: MediaQuery(
            data: mediaQuery,
            child: Container(
              child: child,
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
          ),
        ),
      ),
    );
  }

  MediaQueryData _mediaQueryData(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final padding = deviceInfo.safeAreas;

    final screenSize = deviceInfo.screenSize;

    return mediaQuery.copyWith(
      size: Size(screenSize.width, screenSize.height),
      padding: padding,
      viewInsets: EdgeInsets.zero,
      viewPadding: padding,
      devicePixelRatio: deviceInfo.pixelRatio,
    );
  }
}
