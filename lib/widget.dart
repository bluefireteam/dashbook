import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import './story.dart';
import './property_widgets.dart';

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
    return MaterialApp(theme: theme, routes: {
      '/': (BuildContext context) => Scaffold(
            body: SafeArea(
                child: _DashbookBodyMobile(
              stories: stories,
            )),
          )
    });
  }
}

typedef OnSelectChapter = Function(Chapter chapter);

enum CurrentView {
  STORIES,
  CHAPTER,
  PROPERTIES,
}

class _DashbookBodyMobile extends StatefulWidget {
  final List<Story> stories;

  _DashbookBodyMobile({this.stories});

  @override
  State createState() => _DashbookBodyMobileState();
}

class _DashbookBodyMobileState extends State<_DashbookBodyMobile> {
  CurrentView _currentView;
  Chapter _currentChapter;

  @override
  void initState() {
    super.initState();

    if (widget.stories.isNotEmpty) {
      final story = widget.stories.first;
      _currentView = CurrentView.STORIES;

      if (story.chapters.isNotEmpty) {
        _currentChapter = story.chapters.first;
        _currentView = CurrentView.CHAPTER;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget view;
    if (_currentView == CurrentView.CHAPTER) {
      view = _currentChapter != null
          ? _ChapterPreview(
              currentChapter: _currentChapter, key: Key(_currentChapter.id))
          : null;
    } else if (_currentView == CurrentView.STORIES) {
      view = _StoriesList(
        stories: widget.stories,
        selectedChapter: _currentChapter,
        onSelectChapter: (chapter) {
          setState(() {
            _currentChapter = chapter;
            _currentView = CurrentView.CHAPTER;
          });
        },
      );
    } else {
      view = _PropertiesContainer(currentChapter: _currentChapter);
    }

    return Column(children: [
      Expanded(child: view),
      Container(
        height: 50,
        child: Row(children: [
          Expanded(
              child: _Link(
                  label: 'Stories',
                  textAlign: TextAlign.center,
                  textStyle: TextStyle(
                    fontWeight: _currentView == CurrentView.STORIES
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                  onTap: () {
                    setState(() {
                      _currentView = CurrentView.STORIES;
                    });
                  })),
          Expanded(
              child: _Link(
                  label: 'Preview',
                  textAlign: TextAlign.center,
                  textStyle: TextStyle(
                    fontWeight: _currentView == CurrentView.CHAPTER
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                  onTap: () {
                    setState(() {
                      _currentView = CurrentView.CHAPTER;
                    });
                  })),
          Expanded(
              child: _Link(
                  label: 'Properties',
                  textAlign: TextAlign.center,
                  textStyle: TextStyle(
                    fontWeight: _currentView == CurrentView.PROPERTIES
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                  onTap: () {
                    setState(() {
                      _currentView = CurrentView.PROPERTIES;
                    });
                  })),
        ]),
      )
    ]);
  }
}

class _Link extends StatelessWidget {
  final String label;
  final TextStyle textStyle;
  final void Function() onTap;
  final TextAlign textAlign;
  final EdgeInsets padding;
  final double height;

  _Link(
      {this.label,
      this.onTap,
      this.textStyle,
      this.textAlign,
      this.padding = const EdgeInsets.all(10),
      this.height = 40});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: Container(
          height: height,
          padding: padding,
          child: Text(this.label, textAlign: textAlign, style: textStyle)),
      onTap: onTap,
    );
  }
}

class _StoriesList extends StatelessWidget {
  final List<Story> stories;
  final Chapter selectedChapter;
  final OnSelectChapter onSelectChapter;

  _StoriesList({this.stories, this.selectedChapter, this.onSelectChapter});

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [
      SizedBox(height: 5),
      Text('Stories',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
      SizedBox(height: 10),
    ];

    stories.forEach((story) {
      children.add(Text(story.name,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)));
      children.add(SizedBox(height: 10));

      story.chapters.forEach((chapter) {
        children.add(GestureDetector(
            behavior: HitTestBehavior.opaque,
            child: _Link(
                label: "  ${chapter.name}",
                textAlign: TextAlign.left,
                padding: EdgeInsets.zero,
                height: 20,
                textStyle: TextStyle(
                    fontWeight: chapter.id == selectedChapter.id
                        ? FontWeight.bold
                        : FontWeight.normal)),
            onTap: () {
              onSelectChapter(chapter);
            }));
      });
    });

    return SingleChildScrollView(
        child: Padding(
            padding: EdgeInsets.all(5),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: children)));
  }
}

class _ChapterPreview extends StatelessWidget {
  final Chapter currentChapter;

  _ChapterPreview({this.currentChapter, Key key}) : super(key: key);

  @override
  Widget build(BuildContext ctx) {
    return SingleChildScrollView(child: currentChapter.widget());
  }
}

class _PropertiesContainer extends StatefulWidget {
  final Chapter currentChapter;

  _PropertiesContainer({this.currentChapter});

  @override
  State createState() => _PropertiesContainerState();
}

class _PropertiesContainerState extends State<_PropertiesContainer> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
            children: [
      SizedBox(height: 10),
      Text("Properties",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30))
    ]..addAll(widget.currentChapter.ctx.properties.entries.map((entry) {
                final _onChanged = (_) {
                  setState(() {});
                };
                if (entry.value is Property<String>) {
                  return TextProperty(
                      property: entry.value, onChanged: _onChanged);
                } else if (entry.value is Property<double>) {
                  return NumberProperty(
                      property: entry.value, onChanged: _onChanged);
                } else if (entry.value is ListProperty) {
                  return ListPropertyWidget(
                      property: entry.value, onChanged: _onChanged);
                }
                return null;
              }))));
  }
}
