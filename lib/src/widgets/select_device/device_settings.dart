import 'package:device_frame/device_frame.dart';

/// A class containing information about a mocked user's device and settings.
///
/// Use [deviceInfo] to control the mocked device itself, such as size and
/// visual representation on screen.
///
/// For controlling the user settings for the mocked device, we currently
/// support [textScaleFactor], which sets the text scale factor for the device.
/// It is then applied to the preview the same way as if the user updated these
/// settings in the device preferences.
///
/// The currently supported multiples for [textScaleFactor] that are currently
/// supported are 0.85, 1.0, 1.15 and 1.3. This is a quite normal scale, taken
/// directly from a Pixel 5 running Android 13.
class DeviceSettings {
  final DeviceInfo? deviceInfo;
  final double textScaleFactor;

  DeviceSettings({
    required this.deviceInfo,
    required this.textScaleFactor,
  });

  DeviceSettings copyWith({
    DeviceInfo? deviceInfo,
    double? textScaleFactor,
  }) {
    return DeviceSettings(
      deviceInfo: deviceInfo ?? this.deviceInfo,
      textScaleFactor: textScaleFactor ?? this.textScaleFactor,
    );
  }
}
