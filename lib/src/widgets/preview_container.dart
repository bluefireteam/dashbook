import 'package:dashbook/src/widgets/device_preview.dart';
import 'package:dashbook/src/widgets/helpers.dart';
import 'package:dashbook/src/widgets/select_device/device_settings.dart';
import 'package:material_ui/material_ui.dart';

class PreviewContainer extends StatelessWidget {
  const PreviewContainer({
    required this.child,
    required this.usePreviewSafeArea,
    this.info,
    super.key,
  });

  final Widget child;
  final bool usePreviewSafeArea;
  final String? info;

  @override
  Widget build(BuildContext context) {
    final settings = DeviceSettings.of(context).settings;
    final deviceInfo = settings.deviceInfo;
    final info = this.info;
    final safeAreaBorder = BorderSide(
      color: Theme.of(context).cardColor,
      width: iconSize(context) * 2,
    );

    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: TextScaler.linear(settings.textScaleFactor)),
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: usePreviewSafeArea
                  ? BoxDecoration(
                      border: Border(
                        left: safeAreaBorder,
                        right: safeAreaBorder,
                      ),
                    )
                  : null,
              child: deviceInfo == null
                  ? child
                  : DevicePreview(
                      showDeviceFrame: settings.showDeviceFrame,
                      deviceInfo: deviceInfo,
                      deviceOrientation: settings.orientation,
                      child: child,
                    ),
            ),
          ),
          if (info != null)
            Positioned(
              bottom: 6,
              left: 6,
              right: 6,
              child: Center(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(info),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
