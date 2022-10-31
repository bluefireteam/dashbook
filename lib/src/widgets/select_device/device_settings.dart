import 'package:device_frame/device_frame.dart';

class DeviceSettings {
  final double textScaleFactor;
  final DeviceInfo? deviceInfo;

  DeviceSettings({
    required this.textScaleFactor,
    required this.deviceInfo,
  });

  DeviceSettings copyWith({
    double? textScaleFactor,
    DeviceInfo? deviceInfo,
  }) {
    return DeviceSettings(
      textScaleFactor: textScaleFactor ?? this.textScaleFactor,
      deviceInfo: deviceInfo ?? this.deviceInfo,
    );
  }
}
