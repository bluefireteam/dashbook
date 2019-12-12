import 'package:flutter/material.dart';

class Dashbook extends StatefulWidget {
  final List<Story> _stories = [];

  Story storiesOf(String name) {
    final story = Story(name);
    _stories.add(story);

    return story;
  }

  @override
  State<StatefulWidget> createState() => _DashbookState();
}

class _DashbookState extends State<Dashbook> {

  Chapter _currentChapter;

  @override
  void initState() {
    super.initState();

    if (widget._stories.isNotEmpty) {
      final story = widget._stories.first;

      if (story._chapters.isNotEmpty) {
        _currentChapter = story._chapters.first;
      }
    }
  }

  List<Widget> _buildDrawer(BuildContext context) {
    List<Widget> children = [];

    widget._stories.forEach((story) {
      children.add(ListTile(
              title: Text(
                  story.name,
                  style: TextStyle(fontWeight: FontWeight.bold)
              )
      ));

      story._chapters.forEach((chapter) {
        children.add(
            ListTile(
                title: Text("  ${chapter.name}"),
                onTap: () {
                  setState(() {
                    _currentChapter = chapter;
                  });

                  Navigator.of(context).pop();
                }
            )
        );
      });
    });

    return children;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        routes: {
          '/': (BuildContext context) => Scaffold(
              appBar: AppBar(
                  title: const Text('Dashbook'),
              ),
              body:  _currentChapter?.widget,
              drawer: Drawer(
                  child: ListView(children: _buildDrawer(context))
              )
          )
        }
    );
  }
}

class Story {
  final String name;
  List<Chapter> _chapters = [];

  Decorator _decorator;

  Story(this.name);

  Story add(String name, Widget widget) {
    final chapter = Chapter(name, widget, this);
    _chapters.add(chapter);

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

  final Story _story;

  Chapter(this.name, this._widget, this._story);

  Widget get widget {
    if (_story._decorator != null) {
      return _story._decorator.decorate(_widget);
    }

    return _widget;
  }
}

abstract class Decorator {
  Widget decorate(Widget child);
}

class CenterDecorator extends Decorator {
  @override
  Widget decorate(Widget child) => Center(child: child);
}
