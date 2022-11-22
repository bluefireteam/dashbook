import 'package:alkami_core_dependencies/alkami_core_dependencies.dart';
import '../story.dart';
import 'widgets/property_scaffold.dart';

class TextProperty extends StatefulWidget {
  final Property<String?>? property;
  final PropertyChanged? onChanged;

  TextProperty({
    this.property,
    this.onChanged,
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() =>
      TextPropertyState(property!.getValue()!);
}

class TextPropertyState extends State<TextProperty> {
  TextEditingController controller = TextEditingController();

  TextPropertyState(String value) {
    controller.text = value;
  }

  @override
  Widget build(BuildContext context) {
    return PropertyScaffold(
      label: widget.property!.name,
      child: TextField(
        onChanged: (value) {
          widget.property!.value = value;
          widget.onChanged!(widget.property);
        },
        controller: controller,
      ),
    );
  }
}
