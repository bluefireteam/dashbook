import 'package:dashbook/dashbook.dart';
import 'package:dashbook/src/widgets/select_device/components/device_dropdown.dart';
import 'package:dashbook/src/widgets/select_device/components/text_scale_factor_slider.dart';
import 'package:material_ui/material_ui.dart';

class SelectDevice extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        PropertyScaffold(
          label: 'Select a device frame:',
          child: DeviceDropdown(),
        ),
        SizedBox(height: 12),
        PropertyScaffold(
          label: 'Text scale factor:',
          child: TextScaleFactorSlider(),
        ),
        SizedBox(height: 12),
      ],
    );
  }
}
