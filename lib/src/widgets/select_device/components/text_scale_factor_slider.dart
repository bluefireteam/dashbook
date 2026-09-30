import 'package:dashbook/src/widgets/select_device/device_settings.dart';
import 'package:material_ui/material_ui.dart';

class TextScaleFactorSlider extends StatelessWidget {
  const TextScaleFactorSlider({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceSettings = DeviceSettings.of(context);
    final textScaleFactor = deviceSettings.settings.textScaleFactor;

    return Slider(
      value: textScaleFactor,
      divisions: 3,
      min: 0.85,
      max: 1.3,
      label: textScaleFactor.toString(),
      onChanged: deviceSettings.updateTextScaleFactor,
    );
  }
}
