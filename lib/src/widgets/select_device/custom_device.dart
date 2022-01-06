import 'package:device_frame/device_frame.dart';
import 'package:flutter/material.dart';

class CustomDevice extends StatefulWidget {
  const CustomDevice({
    required this.changeToList,
    this.selectedDevice,
    Key? key,
  }) : super(key: key);
  final VoidCallback changeToList;
  final DeviceInfo? selectedDevice;

  @override
  CustomDeviceState createState() => CustomDeviceState();
}

class CustomDeviceState extends State<CustomDevice> {
  final _widthController = TextEditingController();
  final _heightController = TextEditingController();
  TargetPlatform platform = TargetPlatform.android;

  @override
  void initState() {
    super.initState();
    _widthController.text =
        '${widget.selectedDevice?.screenSize.width ?? 1980}';
    _heightController.text =
        '${widget.selectedDevice?.screenSize.width ?? 1080}';
    if (widget.selectedDevice != null) {
      setPlatform(widget.selectedDevice!.identifier.platform);
    }
  }

  @override
  void dispose() {
    _widthController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  void setPlatform(TargetPlatform selected) =>
      setState(() => platform = selected);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          width: constraints.maxWidth * .5,
          child: Form(
            child: Column(
              children: [
                const Text('Choose your custom setup'),
                if (constraints.maxWidth < 680)
                  Column(
                    children: [
                      _FormField(_heightController, label: 'Height'),
                      const SizedBox(width: 12),
                      _FormField(_widthController, label: 'Width'),
                    ],
                  )
                else
                  Row(
                    children: [
                      Expanded(
                        child: _FormField(_heightController, label: 'Height'),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _FormField(_widthController, label: 'Width'),
                      ),
                    ],
                  ),
                const SizedBox(height: 12),
                _PickPlatform(
                  selected: platform,
                  onSelect: setPlatform,
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
    Key? key,
  }) : super(key: key);
  final TextEditingController controller;
  final String label;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
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
      children: TargetPlatform.values.map((platform) {
        return TextButton(
          onPressed: () => onSelect(platform),
          child: Text(
            platform.name,
            style: TextStyle(
              fontWeight:
                  platform == selected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        );
      }).toList(),
    );
  }
}
