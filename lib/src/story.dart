import 'package:dashbook/dashbook.dart';
import 'package:flutter/material.dart';

class ControlProperty {
  final String key;
  final Object value;

  ControlProperty(this.key, this.value);
}

class Property<T> {
  final String name;

  final T defaultValue;

  T? value;

  final ControlProperty? visibilityControlProperty;

  Property(this.name, this.defaultValue, {this.visibilityControlProperty});

  T getValue() => value ?? defaultValue;

  @override
  String toString() => '$name - ${getValue()}';
}

class ListProperty<T> extends Property<T> {
  final List<T> list;

  ListProperty(
    String name,
    T defaultValue,
    this.list, {
    ControlProperty? visibilityControlProperty,
  }) : super(
          name,
          defaultValue,
          visibilityControlProperty: visibilityControlProperty,
        );
}

class OptionsProperty<T> extends Property<T> {
  final List<PropertyOption<T>> list;

  OptionsProperty(
    String name,
    T defaultValue,
    this.list, {
    ControlProperty? visibilityControlProperty,
  }) : super(
          name,
          defaultValue,
          visibilityControlProperty: visibilityControlProperty,
        );
}

class PropertyOption<T> {
  final String label;
  final T value;

  PropertyOption(this.label, this.value);

  @override
  String toString() {
    return label;
  }
}

class DashbookContext {
  Map<String, Property> properties = {};

  String textProperty(
    String name,
    String defaultValue, {
    ControlProperty? visibilityControlProperty,
  }) {
    if (properties.containsKey(name)) {
      return properties[name]!.getValue() as String;
    } else {
      final property = Property<String>(
        name,
        defaultValue,
        visibilityControlProperty: visibilityControlProperty,
      );
      properties[name] = property;

      return property.getValue();
    }
  }

  double numberProperty(
    String name,
    double defaultValue, {
    ControlProperty? visibilityControlProperty,
  }) {
    if (properties.containsKey(name)) {
      return properties[name]!.getValue() as double;
    } else {
      final property = Property<double>(
        name,
        defaultValue,
        visibilityControlProperty: visibilityControlProperty,
      );
      properties[name] = property;

      return property.getValue();
    }
  }

  bool boolProperty(
    String name,
    bool defaultValue, {
    ControlProperty? visibilityControlProperty,
  }) {
    if (properties.containsKey(name)) {
      return properties[name]!.getValue() as bool;
    } else {
      final property = Property<bool>(
        name,
        defaultValue,
        visibilityControlProperty: visibilityControlProperty,
      );
      properties[name] = property;

      return property.getValue();
    }
  }

  Color colorProperty(
    String name,
    Color defaultValue, {
    ControlProperty? visibilityControlProperty,
  }) {
    if (properties.containsKey(name)) {
      return properties[name]!.getValue() as Color;
    } else {
      final property = Property<Color>(
        name,
        defaultValue,
        visibilityControlProperty: visibilityControlProperty,
      );
      properties[name] = property;

      return property.getValue();
    }
  }

  T listProperty<T>(
    String name,
    T defaultValue,
    List<T> list, {
    ControlProperty? visibilityControlProperty,
  }) {
    if (properties.containsKey(name)) {
      return properties[name]!.getValue() as T;
    } else {
      final property = ListProperty<T>(
        name,
        defaultValue,
        list,
        visibilityControlProperty: visibilityControlProperty,
      );
      properties[name] = property;

      return property.getValue();
    }
  }

  T optionsProperty<T>(
    String name,
    T defaultValue,
    List<PropertyOption<T>> list, {
    ControlProperty? visibilityControlProperty,
  }) {
    if (properties.containsKey(name)) {
      return properties[name]!.getValue() as T;
    } else {
      final property = OptionsProperty<T>(
        name,
        defaultValue,
        list,
        visibilityControlProperty: visibilityControlProperty,
      );
      properties[name] = property;

      return property.getValue();
    }
  }

  EdgeInsets edgeInsetsProperty(
    String name,
    EdgeInsets defaultValue, {
    ControlProperty? visibilityControlProperty,
  }) {
    if (properties.containsKey(name)) {
      return properties[name]!.getValue() as EdgeInsets;
    } else {
      final property = Property<EdgeInsets>(
        name,
        defaultValue,
        visibilityControlProperty: visibilityControlProperty,
      );
      properties[name] = property;

      return property.getValue();
    }
  }

  BorderRadius borderRadiusProperty(
    String name,
    BorderRadius defaultValue, {
    ControlProperty? visibilityControlProperty,
  }) {
    if (properties.containsKey(name)) {
      return properties[name]!.getValue() as BorderRadius;
    } else {
      final property = Property<BorderRadius>(
        name,
        defaultValue,
        visibilityControlProperty: visibilityControlProperty,
      );
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

  Story add(
    String name,
    ChapterBuildFunction buildFn, {
    String? codeLink,
    String? info,
  }) {
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
    final w = _buildFn(ctx);

    return story._decorator?.decorate(w) ?? w;
  }

  String get id => '${story.name}_$name';
}
