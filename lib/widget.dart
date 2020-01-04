import 'package:flutter/material.dart';
import './story.dart';
import './property_widgets.dart';

class _ChapterPreview extends StatefulWidget {
  final Chapter chapter;

  _ChapterPreview({this.chapter, Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ChapterPreviewState(chapter);
}

class _ChapterPreviewState extends State<_ChapterPreview> {
  Chapter _currentChapter;

  _ChapterPreviewState(this._currentChapter);

  @override
  Widget build(BuildContext ctx) {
    final children = [
      Expanded(child: SingleChildScrollView(child: _currentChapter.widget()))
    ];

    if (_currentChapter.ctx.properties.isNotEmpty) {
      children.add(
        Expanded(
            child: SingleChildScrollView(
                child: Column(
                    children: [
          Text("Properties", style: TextStyle(fontWeight: FontWeight.bold))
        ]..addAll(_currentChapter.ctx.properties.entries.map((entry) {
                        final onChanged = (_) {
                          setState(() {});
                        };
                        if (entry.value is Property<String>) {
                          return TextProperty(
                              property: entry.value, onChanged: onChanged);
                        } else if (entry.value is Property<double>) {
                          return NumberProperty(
                              property: entry.value, onChanged: onChanged);
                        } else if (entry.value is ListProperty) {
                          return ListPropertyWidget(
                              property: entry.value, onChanged: onChanged);
                        }
                        return null;
                      }))))),
      );
    }
    return Column(children: children);
  }
}

class Dashbook extends StatefulWidget {
  final List<Story> stories = [];

  Story storiesOf(String name) {
    final story = Story(name);
    stories.add(story);

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

    if (widget.stories.isNotEmpty) {
      final story = widget.stories.first;

      if (story.chapters.isNotEmpty) {
        _currentChapter = story.chapters.first;
      }
    }
  }

  List<Widget> _buildDrawer(BuildContext context) {
    List<Widget> children = [];

    widget.stories.forEach((story) {
      children.add(ListTile(
          title:
              Text(story.name, style: TextStyle(fontWeight: FontWeight.bold))));

      story.chapters.forEach((chapter) {
        children.add(ListTile(
            selected: chapter.id == _currentChapter.id,
            title: Text("  ${chapter.name}"),
            onTap: () {
              setState(() {
                _currentChapter = chapter;
              });

              Navigator.of(context).pop();
            }));
      });
    });

    return children;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(routes: {
      '/': (BuildContext context) => Scaffold(
          appBar: AppBar(
            title: const Text('Dashbook'),
          ),
          body: _currentChapter != null
              ? _ChapterPreview(
                  chapter: _currentChapter, key: Key(_currentChapter.id))
              : null,
          drawer: Drawer(child: ListView(children: _buildDrawer(context))))
    });
  }
}
