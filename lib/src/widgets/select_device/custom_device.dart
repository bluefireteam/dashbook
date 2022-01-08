import 'package:device_frame/device_frame.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const String kCustomDeviceId = 'custom_device';
const String kCustomDeviceName = 'Custom Device';

class CustomDevice extends StatefulWidget {
  const CustomDevice({
    required this.onUpdateDevice,
    required this.changeToList,
    required this.formKey,
    this.selectedDevice,
    Key? key,
  }) : super(key: key);
  final VoidCallback changeToList;
  final DeviceInfo? selectedDevice;
  final void Function(DeviceInfo) onUpdateDevice;
  final GlobalKey<FormState> formKey;

  @override
  CustomDeviceState createState() => CustomDeviceState();
}

class CustomDeviceState extends State<CustomDevice> {
  final _widthController = TextEditingController();
  final _heightController = TextEditingController();
  late DeviceInfo custom;

  @override
  void initState() {
    super.initState();
    custom = widget.selectedDevice ?? Devices.android.largeTablet;
    widget.onUpdateDevice(custom);
    _widthController.text = '${custom.screenSize.width}';
    _heightController.text = '${custom.screenSize.height}';
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
    custom = DeviceInfo.genericTablet(
      platform: platform ?? custom.identifier.platform,
      id: kCustomDeviceId,
      name: kCustomDeviceName,
      screenSize: Size(
        width ?? custom.screenSize.width,
        height ?? custom.screenSize.height,
      ),
    );

    widget.onUpdateDevice(custom);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          width: constraints.maxWidth * .5,
          child: Form(
            key: widget.formKey,
            child: Column(
              children: [
                const Text('Choose your custom setup'),
                if (constraints.maxWidth < 680)
                  Column(
                    children: [
                      _FormField(
                        _heightController,
                        label: 'Height',
                        onUpdate: (value) => _setCustom(
                          height: value.toDouble(),
                        ),
                      ),
                      const SizedBox(width: 12),
                      _FormField(
                        _widthController,
                        label: 'Width',
                        onUpdate: (value) => _setCustom(
                          width: value.toDouble(),
                        ),
                      ),
                    ],
                  )
                else
                  Row(
                    children: [
                      Expanded(
                        child: _FormField(
                          _heightController,
                          label: 'Height',
                          onUpdate: (value) => _setCustom(
                            height: value.toDouble(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _FormField(
                          _widthController,
                          label: 'Width',
                          onUpdate: (value) => _setCustom(
                            width: value.toDouble(),
                          ),
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 12),
                _PickPlatform(
                  selected: custom.identifier.platform,
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
          ),
        );
      },
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
    if (value == null || value.isEmpty) return 'Value could not be empty';
    final isDigitsOnly = num.tryParse(value);
    if (isDigitsOnly == null) return 'Input needs to be digits only';
    if (isDigitsOnly > 5000) return 'Try to use a value less than 5000';
    if (isDigitsOnly < 100) return 'Try to use a value greather than 100';
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
