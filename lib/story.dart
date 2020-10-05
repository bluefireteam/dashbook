import 'package:flutter/material.dart';
import './decorator.dart';

class Property<T> {
  final String name;

  final T defaultValue;

  T value;

  Property(this.name, this.defaultValue);

  T getValue() => value ?? defaultValue;

  @override
  toString() => "$name - ${getValue()}";
}

class ListProperty<T> extends Property<T> {
  final List<T> list;

  ListProperty(String name, T defaultValue, this.list)
      : super(name, defaultValue);
}

class DashbookContext {
  Map<String, Property> properties = {};

  String textProperty(String name, String defaultValue) {
    if (properties.containsKey(name)) {
      return properties[name].getValue();
    } else {
      final property = Property<String>(name, defaultValue);
      properties[name] = property;

      return property.getValue();
    }
  }

  double numberProperty(String name, double defaultValue) {
    if (properties.containsKey(name)) {
      return properties[name].getValue();
    } else {
      final property = Property<double>(name, defaultValue);
      properties[name] = property;

      return property.getValue();
    }
  }

  bool boolProperty(String name, bool defaultValue) {
    if (properties.containsKey(name)) {
      return properties[name].getValue();
    } else {
      final property = Property<bool>(name, defaultValue);
      properties[name] = property;

      return property.getValue();
    }
  }

  Color colorProperty(String name, Color defaultValue) {
    if (properties.containsKey(name)) {
      return properties[name].getValue();
    } else {
      final property = Property<Color>(name, defaultValue);
      properties[name] = property;

      return property.getValue();
    }
  }

  T listProperty<T>(String name, T defaultValue, List<T> list) {
    if (properties.containsKey(name)) {
      return properties[name].getValue();
    } else {
      final property = ListProperty<T>(name, defaultValue, list);
      properties[name] = property;

      return property.getValue();
    }
  }

  EdgeInsets edgeInsetsProperty(String name, EdgeInsets defaultValue) {
    if (properties.containsKey(name)) {
      return properties[name].getValue();
    } else {
      final property = Property<EdgeInsets>(name, defaultValue);
      properties[name] = property;

      return property.getValue();
    }
  }
}

typedef ChapterBuildFunction = Widget Function(DashbookContext context);

class Story {
  final String name;
  List<Chapter> chapters = [];

  Decorator _decorator;

  Story(this.name);

  Story add(String name, ChapterBuildFunction buildFn) {
    final _chapter = Chapter(name, buildFn, this);
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
  DashbookContext ctx;

  final Story story;

  Chapter(this.name, this._buildFn, this.story) {
    ctx = DashbookContext();
  }

  Widget widget() {
    final Widget w = _buildFn(ctx);

    if (story._decorator != null) {
      return story._decorator.decorate(w);
    }

    return w;
  }

  String get id => "${story.name}#$name";
}
