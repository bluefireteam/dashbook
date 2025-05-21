import 'package:dashbook/src/widgets/select_device/components/text_scale_factor_slider.dart';
import 'package:dashbook/src/widgets/select_device/device_settings.dart';
import 'package:dashbook/src/widgets/select_device/select_device.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomDevice extends StatefulWidget {
  const CustomDevice({
    required this.changeToList,
    required this.formKey,
    super.key,
  });
  final VoidCallback changeToList;
  final GlobalKey<FormState> formKey;

  @override
  CustomDeviceState createState() => CustomDeviceState();
}

class CustomDeviceState extends State<CustomDevice> {
  final _widthController = TextEditingController();
  final _heightController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final deviceInfo =
        DeviceSettings.of(context, listen: false).settings.deviceInfo!;
    _widthController.text = '${deviceInfo.screenSize.width.toInt()}';
    _heightController.text = '${deviceInfo.screenSize.height.toInt()}';
  }

  @override
  void dispose() {
    _widthController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  void _setCustom({
    double? height,
    double? width,
    TargetPlatform? platform,
  }) {
    DeviceSettings.of(context, listen: false).updateDeviceData(
      height: height,
      width: width,
      platform: platform,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _FormField(
                  _widthController,
                  label: 'Width',
                  onUpdate: (value) => _setCustom(
                    width: value.toDouble(),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _FormField(
                  _heightController,
                  label: 'Height',
                  onUpdate: (value) => _setCustom(
                    height: value.toDouble(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const DevicePropertyScaffold(
            label: 'Text scale factor:',
            child: TextScaleFactorSlider(),
          ),
          const SizedBox(height: 12),
          _PickPlatform(
            onSelect: (platform) => _setCustom(platform: platform),
          ),
        ],
      ),
    );
  }
}

class _FormField extends StatelessWidget {
  const _FormField(
    this.controller, {
    required this.label,
    required this.onUpdate,
  });
  final TextEditingController controller;
  final String label;
  final void Function(num) onUpdate;

  String? _numValidator(String? value) {
    if (value == null || value.isEmpty) return 'Value can not be empty';
    final isDigitsOnly = num.tryParse(value);
    if (isDigitsOnly == null) return 'Input needs to be digits only';
    if (isDigitsOnly > 5000) return 'Try to use a value less than 5000';
    if (isDigitsOnly < 100) return 'Try to use a value greather than 100';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      keyboardType: TextInputType.number,
      validator: _numValidator,
      onChanged: (value) {
        final parsedValue = num.tryParse(value);
        if (parsedValue != null) onUpdate(parsedValue);
      },
      decoration: InputDecoration(
        label: Text(label),
      ),
    );
  }
}

class _PickPlatform extends StatelessWidget {
  const _PickPlatform({
    required this.onSelect,
  });
  final void Function(TargetPlatform) onSelect;

  @override
  Widget build(BuildContext context) {
    final selected =
        DeviceSettings.of(context).settings.deviceInfo!.identifier.platform;
    return Wrap(
      children: [TargetPlatform.android, TargetPlatform.iOS].map((platform) {
        return TextButton(
          onPressed: () => onSelect(platform),
          child: Text(
            _getPlatformName(platform),
            style: TextStyle(
              fontWeight:
                  platform == selected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        );
      }).toList(),
    );
  }

  String _getPlatformName(TargetPlatform platform) =>
      platform.toString().split('.').last;
}
