import 'package:flutter/material.dart';
import './story.dart';

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
              title: Text(
                  story.name,
                  style: TextStyle(fontWeight: FontWeight.bold)
              )
      ));

      story.chapters.forEach((chapter) {
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

