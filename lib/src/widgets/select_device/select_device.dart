import 'package:dashbook/src/widgets/property_widgets/widgets/title_with_tooltip.dart';
import 'package:dashbook/src/widgets/select_device/components/device_dropdown.dart';
import 'package:dashbook/src/widgets/select_device/components/text_scale_factor_slider.dart';
import 'package:flutter/material.dart';

class SelectDevice extends StatelessWidget {
  const SelectDevice({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        DevicePropertyScaffold(
          label: 'Select a device frame:',
          child: DeviceDropdown(),
        ),
        SizedBox(height: 12),
        DevicePropertyScaffold(
          label: 'Text scale factor:',
          child: TextScaleFactorSlider(),
        ),
        SizedBox(height: 12),
      ],
    );
  }
}

class DevicePropertyScaffold extends StatelessWidget {
  final String label;
  final Widget child;
  final String? tooltipMessage;

  const DevicePropertyScaffold({
    Key? key,
    required this.label,
    required this.child,
    this.tooltipMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: tooltipMessage != null
                ? TitleWithTooltip(
                    label: label,
                    tooltipMessage: tooltipMessage!,
                  )
                : Text(label),
          ),
          Expanded(flex: 6, child: child)
        ],
      ),
    );
  }
}
