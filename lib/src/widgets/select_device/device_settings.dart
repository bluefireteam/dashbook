import 'package:device_frame/device_frame.dart';
import 'package:flutter/widgets.dart';

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
@immutable
class DeviceSettingsData {
  final DeviceInfo? deviceInfo;
  final double textScaleFactor;

  const DeviceSettingsData({
    required this.deviceInfo,
    required this.textScaleFactor,
  });

  DeviceSettingsData copyWith({
    DeviceInfo? deviceInfo,
    double? textScaleFactor,
  }) {
    return DeviceSettingsData(
      deviceInfo: deviceInfo ?? this.deviceInfo,
      textScaleFactor: textScaleFactor ?? this.textScaleFactor,
    );
  }
}

class DeviceSettings extends StatefulWidget {
  final Widget child;

  const DeviceSettings({super.key, required this.child});

  static DeviceSettingsState of(BuildContext context) {
    final result =
        context.dependOnInheritedWidgetOfExactType<_DeviceSettings>();
    assert(result != null, 'No DeviceSettings found in context');
    return result!.data;
  }

  @override
  State<DeviceSettings> createState() => DeviceSettingsState();
}

class DeviceSettingsState extends State<DeviceSettings> {
  DeviceSettingsData _settings = const DeviceSettingsData(
    deviceInfo: null,
    textScaleFactor: 1,
  );

  DeviceSettingsData get settings => _settings;

  set settings(DeviceSettingsData newSettings) => setState(() {
        _settings = newSettings;
      });

  void updateTextScaleFactor([double textScaleFactor = 1.0]) {
    settings = DeviceSettingsData(
      textScaleFactor: textScaleFactor,
      deviceInfo: _settings.deviceInfo,
    );
  }

  void updateDevice(DeviceInfo? deviceInfo) {
    settings = DeviceSettingsData(
      textScaleFactor: _settings.textScaleFactor,
      deviceInfo: deviceInfo,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _DeviceSettings(
      _settings,
      data: this,
      child: widget.child,
    );
  }
}

class _DeviceSettings extends InheritedWidget {
  final DeviceSettingsData settings;
  final DeviceSettingsState data;

  const _DeviceSettings(
    this.settings, {
    required this.data,
    required super.child,
  });

  @override
  bool updateShouldNotify(_DeviceSettings oldWidget) {
    return settings != oldWidget.settings;
  }
}
