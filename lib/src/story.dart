import 'package:flutter/material.dart';
import './decorator.dart';

class ControlProperty {
  final String key;
  final Object value;

  ControlProperty(this.key, this.value);
}

class Property<T> {
  final String name;

  final T defaultValue;

  T? value;

  final ControlProperty? controlProperty;

  Property(this.name, this.defaultValue, {this.controlProperty});

  T getValue() => value ?? defaultValue;

  @override
  toString() => "$name - ${getValue()}";
}

class ListProperty<T> extends Property<T> {
  final List<T> list;

  ListProperty(String name, T defaultValue, this.list,
      {ControlProperty? controlProperty})
      : super(name, defaultValue, controlProperty: controlProperty);
}

class DashbookContext {
  Map<String, Property> properties = {};

  String textProperty(String name, String defaultValue,
      {ControlProperty? controlProperty}) {
    if (properties.containsKey(name)) {
      return properties[name]!.getValue();
    } else {
      final property = Property<String>(name, defaultValue);
      properties[name] = property;

      return property.getValue();
    }
  }

  double numberProperty(String name, double defaultValue,
      {ControlProperty? controlProperty}) {
    if (properties.containsKey(name)) {
      return properties[name]!.getValue();
    } else {
      final property = Property<double>(name, defaultValue,
          controlProperty: controlProperty);
      properties[name] = property;

      return property.getValue();
    }
  }

  bool boolProperty(String name, bool defaultValue,
      {ControlProperty? controlProperty}) {
    if (properties.containsKey(name)) {
      return properties[name]!.getValue();
    } else {
      final property =
          Property<bool>(name, defaultValue, controlProperty: controlProperty);
      properties[name] = property;

      return property.getValue();
    }
  }

  Color colorProperty(String name, Color defaultValue,
      {ControlProperty? controlProperty}) {
    if (properties.containsKey(name)) {
      return properties[name]!.getValue();
    } else {
      final property =
          Property<Color>(name, defaultValue, controlProperty: controlProperty);
      properties[name] = property;

      return property.getValue();
    }
  }

  T listProperty<T>(String name, T defaultValue, List<T> list,
      {ControlProperty? controlProperty}) {
    if (properties.containsKey(name)) {
      return properties[name]!.getValue();
    } else {
      final property = ListProperty<T>(name, defaultValue, list,
          controlProperty: controlProperty);
      properties[name] = property;

      return property.getValue();
    }
  }

  EdgeInsets edgeInsetsProperty(String name, EdgeInsets defaultValue,
      {ControlProperty? controlProperty}) {
    if (properties.containsKey(name)) {
      return properties[name]!.getValue();
    } else {
      final property = Property<EdgeInsets>(name, defaultValue,
          controlProperty: controlProperty);
      properties[name] = property;

      return property.getValue();
    }
  }

  BorderRadius borderRadiusProperty(String name, BorderRadius defaultValue,
      {ControlProperty? controlProperty}) {
    if (properties.containsKey(name)) {
      return properties[name]!.getValue();
    } else {
      final property = Property<BorderRadius>(name, defaultValue,
          controlProperty: controlProperty);
      properties[name] = property;

      return property.getValue();
    }
  }
}

typedef ChapterBuildFunction = Widget Function(DashbookContext context);

class Story {
  final String name;
  List<Chapter> chapters = [];

  Decorator? _decorator;

  Story(this.name);

  Story add(String name, ChapterBuildFunction buildFn,
      {String? codeLink, String? info}) {
    final _chapter = Chapter(
      name,
      buildFn,
      this,
      codeLink: codeLink,
      info: info,
    );
    chapters.add(_chapter);

    return this;
  }

  Story decorator(Decorator decorator) {
    _decorator = decorator;

    return this;
  }
}

class Chapter {
  final ChapterBuildFunction _buildFn;
  final String name;
  DashbookContext ctx = DashbookContext();
  final String? codeLink;
  final String? info;

  final Story story;

  Chapter(this.name, this._buildFn, this.story, {this.codeLink, this.info});

  Widget widget() {
    final Widget w = _buildFn(ctx);

    return story._decorator?.decorate(w) ?? w;
  }

  String get id => "${story.name}_$name";
}
