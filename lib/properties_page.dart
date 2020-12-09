import 'package:dashbook/chapter_preview.dart';
import 'package:dashbook/dashbook.dart';
import 'package:flutter/material.dart';
import 'property_widgets/properties.dart' as p;

class PropertiesPage extends StatefulWidget {
  final Chapter chapter;

  PropertiesPage(this.chapter);

  @override
  _PropertiesPageState createState() => _PropertiesPageState();
}

class _PropertiesPageState extends State<PropertiesPage> {
  @override
  void initState() {
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Properties"),
      ),
      body: Container(
        child: Column(
          children: [
            ChapterPreview(
              currentChapter: widget.chapter,
              key: Key(widget.chapter.id),
            ),
            _PropertiesContainer(currentChapter: widget.chapter),
            MaterialButton(
              child: Text("Aplicar mudanças"),
              color: Colors.blue,
              onPressed: () {
                setState(() {});
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _PropertiesContainer extends StatefulWidget {
  final Chapter currentChapter;
  final OnPropertyChange onPropertyChange;

  _PropertiesContainer({this.currentChapter, this.onPropertyChange});

  @override
  State createState() => _PropertiesContainerState();
}

class _PropertiesContainerState extends State<_PropertiesContainer> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 10),
          Text(
            "Properties",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
          ),
        ]..addAll(
            widget.currentChapter.ctx.properties.entries.map((entry) {
              final _propertyKey =
                  Key("${widget.currentChapter.id}#${entry.value.name}");
              final _onChanged = (chapter) {
                setState(() {});
                if (widget.onPropertyChange != null) {
                  widget.onPropertyChange();
                }
              };
              if (entry.value is ListProperty) {
                return p.ListPropertyWidget(
                  property: entry.value,
                  onChanged: _onChanged,
                  key: _propertyKey,
                );
              } else if (entry.value is Property<String>) {
                return p.TextProperty(
                  property: entry.value,
                  onChanged: _onChanged,
                  key: _propertyKey,
                );
              } else if (entry.value is Property<double>) {
                return p.NumberProperty(
                  property: entry.value,
                  onChanged: _onChanged,
                  key: _propertyKey,
                );
              } else if (entry.value is Property<bool>) {
                return p.BoolProperty(
                  property: entry.value,
                  onChanged: _onChanged,
                  key: _propertyKey,
                );
              } else if (entry.value is Property<Color>) {
                return p.ColorProperty(
                  property: entry.value,
                  onChanged: _onChanged,
                  key: _propertyKey,
                );
              } else if (entry.value is Property<EdgeInsets>) {
                return p.EdgeInsetsProperty(
                  property: entry.value,
                  onChanged: _onChanged,
                  key: _propertyKey,
                );
              } else if (entry.value is Property<BorderRadius>) {
                return p.BorderRadiusProperty(
                  property: entry.value,
                  onChanged: _onChanged,
                  key: _propertyKey,
                );
              }
              return Container();
            }),
          ),
      ),
    );
  }
}
