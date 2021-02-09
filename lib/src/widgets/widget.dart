import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

import './properties_container.dart';
import './stories_list.dart';
import '../story.dart';

class Dashbook extends StatelessWidget {
  final List<Story> stories = [];
  final ThemeData theme;

  Dashbook({this.theme});

  Story storiesOf(String name) {
    final story = Story(name);
    stories.add(story);

    return story;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme,
      routes: {
        '/': (BuildContext context) {
          return Scaffold(
            body: SafeArea(
              child: _DashbookBody(stories: stories),
            ),
          );
        },
      },
    );
  }
}


enum CurrentView {
  STORIES,
  CHAPTER,
  PROPERTIES,
}

class _DashbookBody extends StatefulWidget {
  final List<Story> stories;

  _DashbookBody({this.stories});

  @override
  State createState() => _DashbookBodyState();
}

class _DashbookBodyState extends State<_DashbookBody> {
  Chapter _currentChapter;
  bool _isStoriesOpen = false;
  bool _isPropertiesOpen = false;

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

  bool _hasProperties() => _currentChapter.ctx.properties.isNotEmpty;
  double _rightIconTop(int index) => 10.0 + index * 25.0;

  Future<void> _launchURL(String url) async {
    if (await url_launcher.canLaunch(url)) {
      await url_launcher.launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        final chapterWidget = _currentChapter?.widget(constraints);

        int _rightIconIndex = 0;

        return Stack(
          children: [
            Positioned.fill(child: chapterWidget),
            if (_hasProperties())
              Positioned(
                top: _rightIconTop(_rightIconIndex++),
                right: 10,
                child: GestureDetector(
                  child: Icon(Icons.mode_edit),
                  onTap: () => setState(() => _isPropertiesOpen = true),
                ),
              ),
            if (_currentChapter?.codeLink != null)
              Positioned(
                top: _rightIconTop(_rightIconIndex++),
                right: 10,
                child: GestureDetector(
                  child: Icon(Icons.code),
                  onTap: () => _launchURL(_currentChapter.codeLink),
                ),
              ),
            if (_isStoriesOpen)
              Positioned(
                top: 0,
                left: 0,
                bottom: 0,
                child: StoriesList(
                  stories: widget.stories,
                  selectedChapter: _currentChapter,
                  onCancel: () => setState(() => _isStoriesOpen = false),
                  onSelectChapter: (chapter) {
                    setState(() {
                      _currentChapter = chapter;
                      _isStoriesOpen = false;
                    });
                  },
                ),
              ),
            if (_isPropertiesOpen)
              Positioned(
                top: 0,
                right: 0,
                bottom: 0,
                child: PropertiesContainer(
                  currentChapter: _currentChapter,
                  onCancel: () => setState(() => _isPropertiesOpen = false),
                  onPropertyChange: () {
                    setState(() {});
                  },
                ),
              ),
            if (!_isStoriesOpen)
              Positioned(
                top: 5,
                left: 10,
                child: GestureDetector(
                  child: Icon(Icons.menu),
                  onTap: () => setState(() => _isStoriesOpen = true),
                ),
              ),
          ],
        );
      },
    );
  }
}
