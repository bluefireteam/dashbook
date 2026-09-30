import 'package:device_frame/device_frame.dart';
import 'package:material_ui/material_ui.dart';

class DevicePreview extends StatelessWidget {
  const DevicePreview({
    required this.child,
    required this.deviceInfo,
    required this.deviceOrientation,
    required this.showDeviceFrame,
    super.key,
  });

  final Widget child;
  final DeviceInfo deviceInfo;
  final Orientation deviceOrientation;
  final bool showDeviceFrame;

  MediaQueryData _mediaQueryData(BuildContext context) {
    final isRotated = deviceInfo.isLandscape(deviceOrientation);

    final padding = isRotated
        ? (deviceInfo.rotatedSafeAreas ?? deviceInfo.safeAreas)
        : deviceInfo.safeAreas;

    final screenSize = deviceInfo.screenSize;

    return MediaQuery.of(context).copyWith(
      size: isRotated ? screenSize.flipped : screenSize,
      padding: padding,
      viewInsets: EdgeInsets.zero,
      viewPadding: padding,
      devicePixelRatio: deviceInfo.pixelRatio,
    );
  }

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
            child: ColoredBox(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
