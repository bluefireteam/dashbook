import 'package:dashbook/src/widgets/select_device/device_settings.dart';
import 'package:flutter/material.dart';

class TextScaleFactorSlider extends StatelessWidget {
  const TextScaleFactorSlider({super.key});

  @override
  Widget build(BuildContext context) {
    final textScaleFactor = DeviceSettings.of(context).settings.textScaleFactor;
    return Slider(
      value: textScaleFactor,
      divisions: 3,
      min: 0.85,
      max: 1.3,
      label: textScaleFactor.toString(),
      onChanged:
          DeviceSettings.of(context, listen: false).updateTextScaleFactor,
    );
  }
}
