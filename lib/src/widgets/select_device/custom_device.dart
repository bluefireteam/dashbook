import 'package:dashbook/src/widgets/select_device/device_settings.dart';
import 'package:dashbook/src/widgets/select_device/select_device.dart';
import 'package:device_frame/device_frame.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const String kCustomDeviceId = 'custom_device';
const String kCustomDeviceName = 'Custom Device';

class CustomDevice extends StatefulWidget {
  const CustomDevice({
    required this.changeToList,
    required this.formKey,
    required this.deviceInfo,
    required this.textScaleFactor,
    Key? key,
  }) : super(key: key);
  final VoidCallback changeToList;
  final DeviceInfo deviceInfo;
  final double textScaleFactor;
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
    _widthController.text = '${widget.deviceInfo.screenSize.width.toInt()}';
    _heightController.text = '${widget.deviceInfo.screenSize.height.toInt()}';
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
    DeviceSettings.of(context).updateDevice(
      DeviceInfo.genericTablet(
        platform: platform ?? widget.deviceInfo.identifier.platform,
        id: kCustomDeviceId,
        name: kCustomDeviceName,
        screenSize: Size(
          width ?? widget.deviceInfo.screenSize.width,
          height ?? widget.deviceInfo.screenSize.height,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          const Text('Choose your custom setup'),
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
          DevicePropertyScaffold(
            label: 'Text scale factor:',
            child: Slider(
              value: widget.textScaleFactor,
              divisions: 3,
              min: 0.85,
              max: 1.3,
              label: widget.textScaleFactor.toString(),
              onChanged: DeviceSettings.of(context).updateTextScaleFactor,
            ),
          ),
          const SizedBox(height: 12),
          _PickPlatform(
            selected: widget.deviceInfo.identifier.platform,
            onSelect: (platform) =>
                setState(() => _setCustom(platform: platform)),
          ),
          const SizedBox(height: 20),
          OutlinedButton(
            onPressed: widget.changeToList,
            child: const Text('Devices List'),
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
    Key? key,
  }) : super(key: key);
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
    required this.selected,
    required this.onSelect,
    Key? key,
  }) : super(key: key);
  final TargetPlatform selected;
  final void Function(TargetPlatform) onSelect;

  @override
  Widget build(BuildContext context) {
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
