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

  final String? tooltipMessage;

  T? value;

  final ControlProperty? visibilityControlProperty;

  Property(
    this.name,
    this.defaultValue, {
    this.tooltipMessage,
    this.visibilityControlProperty,
  });

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
    String? tooltipMessage,
    ControlProperty? visibilityControlProperty,
  }) : super(
          name,
          defaultValue,
          tooltipMessage: tooltipMessage,
          visibilityControlProperty: visibilityControlProperty,
        );
}

class OptionsProperty<T> extends Property<T> {
  final List<PropertyOption<T>> list;

  OptionsProperty(
    String name,
    T defaultValue,
    this.list, {
    String? tooltipMessage,
    ControlProperty? visibilityControlProperty,
  }) : super(
          name,
          defaultValue,
          tooltipMessage: tooltipMessage,
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
    String? tooltipMessage,
    ControlProperty? visibilityControlProperty,
  }) {
    if (properties.containsKey(name)) {
      return properties[name]!.getValue() as String;
    } else {
      final property = Property<String>(
        name,
        defaultValue,
        tooltipMessage: tooltipMessage,
        visibilityControlProperty: visibilityControlProperty,
      );
      properties[name] = property;

      return property.getValue();
    }
  }

  double numberProperty(
    String name,
    double defaultValue, {
    String? tooltipMessage,
    ControlProperty? visibilityControlProperty,
  }) {
    if (properties.containsKey(name)) {
      return properties[name]!.getValue() as double;
    } else {
      final property = Property<double>(
        name,
        defaultValue,
        tooltipMessage: tooltipMessage,
        visibilityControlProperty: visibilityControlProperty,
      );
      properties[name] = property;

      return property.getValue();
    }
  }

  bool boolProperty(
    String name,
    bool defaultValue, {
    String? tooltipMessage,
    ControlProperty? visibilityControlProperty,
  }) {
    if (properties.containsKey(name)) {
      return properties[name]!.getValue() as bool;
    } else {
      final property = Property<bool>(
        name,
        defaultValue,
        tooltipMessage: tooltipMessage,
        visibilityControlProperty: visibilityControlProperty,
      );
      properties[name] = property;

      return property.getValue();
    }
  }

  Color colorProperty(
    String name,
    Color defaultValue, {
    String? tooltipMessage,
    ControlProperty? visibilityControlProperty,
  }) {
    if (properties.containsKey(name)) {
      return properties[name]!.getValue() as Color;
    } else {
      final property = Property<Color>(
        name,
        defaultValue,
        tooltipMessage: tooltipMessage,
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
    String? tooltipMessage,
    ControlProperty? visibilityControlProperty,
  }) {
    if (properties.containsKey(name)) {
      return properties[name]!.getValue() as T;
    } else {
      final property = ListProperty<T>(
        name,
        defaultValue,
        list,
        tooltipMessage: tooltipMessage,
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
    String? tooltipMessage,
    ControlProperty? visibilityControlProperty,
  }) {
    if (properties.containsKey(name)) {
      return properties[name]!.getValue() as T;
    } else {
      final property = OptionsProperty<T>(
        name,
        defaultValue,
        list,
        tooltipMessage: tooltipMessage,
        visibilityControlProperty: visibilityControlProperty,
      );
      properties[name] = property;

      return property.getValue();
    }
  }

  EdgeInsets edgeInsetsProperty(
    String name,
    EdgeInsets defaultValue, {
    String? tooltipMessage,
    ControlProperty? visibilityControlProperty,
  }) {
    if (properties.containsKey(name)) {
      return properties[name]!.getValue() as EdgeInsets;
    } else {
      final property = Property<EdgeInsets>(
        name,
        defaultValue,
        tooltipMessage: tooltipMessage,
        visibilityControlProperty: visibilityControlProperty,
      );
      properties[name] = property;

      return property.getValue();
    }
  }

  BorderRadius borderRadiusProperty(
    String name,
    BorderRadius defaultValue, {
    String? tooltipMessage,
    ControlProperty? visibilityControlProperty,
  }) {
    if (properties.containsKey(name)) {
      return properties[name]!.getValue() as BorderRadius;
    } else {
      final property = Property<BorderRadius>(
        name,
        defaultValue,
        tooltipMessage: tooltipMessage,
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
