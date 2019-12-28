import 'package:flutter/material.dart';
import './decorator.dart';

class Property <T> {
  final String name;

  final T defaultValue;

  T value;

  Property(this.name, this.defaultValue);

  T getValue() => value ?? defaultValue;

  @override
  toString() => "$name - ${getValue()}";
}

class DashbookContext {
  Map<String, Property> properties = {};

  Property textProperty(String name, String defaultValue) {
    if (properties.containsKey(name)) {
      return properties[name];
    } else {
      final property = Property<String>(name, defaultValue);
      properties[name] = property;

      return property;
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
