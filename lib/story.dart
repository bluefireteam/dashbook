import 'package:flutter/material.dart';
import './decorator.dart';

class Property<T> {
  final String name;

  final T defaultValue;

  T? value;

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
  /// Contain the current BoxConstraints of the area available for the Chapter
  late BoxConstraints constraints;
  Map<String, Property> properties = {};

  String textProperty(String name, String defaultValue) {
    return properties
        .putIfAbsent(name, () => Property<String>(name, defaultValue))
        .getValue();
  }

  double numberProperty(String name, double defaultValue) {
    return properties
        .putIfAbsent(name, () => Property<double>(name, defaultValue))
        .getValue();
  }

  bool boolProperty(String name, bool defaultValue) {
    return properties
        .putIfAbsent(name, () => Property<bool>(name, defaultValue))
        .getValue();
  }

  Color colorProperty(String name, Color defaultValue) {
    return properties
        .putIfAbsent(name, () => Property<Color>(name, defaultValue))
        .getValue();
  }

  T listProperty<T>(String name, T defaultValue, List<T> list) {
    return properties
        .putIfAbsent(name, () => ListProperty<T>(name, defaultValue, list))
        .getValue();
  }

  EdgeInsets edgeInsetsProperty(String name, EdgeInsets defaultValue) {
    return properties
        .putIfAbsent(name, () => Property<EdgeInsets>(name, defaultValue))
        .getValue();
  }

  BorderRadius borderRadiusProperty(String name, BorderRadius defaultValue) {
    return properties
        .putIfAbsent(name, () => Property<BorderRadius>(name, defaultValue))
        .getValue();
  }
}

typedef ChapterBuildFunction = Widget Function(DashbookContext context);

class Story {
  final String name;
  List<Chapter> chapters = [];

  Decorator? _decorator;

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

  Chapter(this.name, this._buildFn, this.story) : ctx = DashbookContext();

  Widget widget(BoxConstraints constraints) {
    ctx.constraints = constraints;
    final Widget w = _buildFn(ctx);

    return story._decorator?.decorate(w) ?? w;
  }

  String get id => "${story.name}#$name";
}
