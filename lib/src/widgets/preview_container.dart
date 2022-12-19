import 'package:dashbook/src/device_size_extension.dart';
import 'package:dashbook/src/widgets/device_preview.dart';
import 'package:dashbook/src/widgets/helpers.dart';
import 'package:dashbook/src/widgets/select_device/device_settings.dart';
import 'package:flutter/material.dart';

class PreviewContainer extends StatelessWidget {
  final bool usePreviewSafeArea;
  final Widget child;
  final bool isIntrusiveSideMenuOpen;
  final String? info;

  const PreviewContainer({
    required Key key,
    required this.child,
    required this.usePreviewSafeArea,
    required this.isIntrusiveSideMenuOpen,
    this.info,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceInfo = DeviceSettings.of(context).settings;

    final preview = deviceInfo.deviceInfo != null
        ? DevicePreview(
            showDeviceFrame: deviceInfo.showDeviceFrame,
            deviceInfo: deviceInfo.deviceInfo!,
            deviceOrientation: deviceInfo.orientation,
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
        : child;

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaleFactor: deviceInfo.textScaleFactor,
      ),
      child: Positioned(
        top: 0,
        bottom: 0,
        left: 0,
        right: (context.isNotPhoneSize && isIntrusiveSideMenuOpen)
            ? sideBarSizeProperties(context)
            : 0,
        child: info == null
            ? preview
            : Stack(
                children: [
                  Positioned.fill(child: preview),
                  Positioned(
                    bottom: 6,
                    left: 6,
                    right: 6,
                    child: Center(
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(info!),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
