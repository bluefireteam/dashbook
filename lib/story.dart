import 'package:flutter/material.dart';
import './decorator.dart';

class Story {
  final String name;
  List<Chapter> chapters = [];

  Decorator _decorator;

  Story(this.name);

  Story add(String name, Widget widget) {
    final chapter = Chapter(name, widget, this);
    chapters.add(chapter);

    return this;
  }

  Story decorator(Decorator decorator) {
    _decorator = decorator;

    return this;
  }
}

class Chapter {
  final Widget _widget;
  final String name;

  final Story story;

  Chapter(this.name, this._widget, this.story);

  Widget get widget {
    if (story._decorator != null) {
      return story._decorator.decorate(_widget);
    }

    return _widget;
  }
}
