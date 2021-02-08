import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import './story.dart';
import 'property_widgets/properties.dart' as p;
import 'package:url_launcher/url_launcher.dart' as url_launcher;

bool isLargeScreen(BuildContext context) =>
    MediaQuery.of(context).size.width > 768;

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

typedef OnSelectChapter = Function(Chapter chapter);

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
            if (_isStoriesOpen)
              Positioned(
                top: 5,
                left: 10,
                child: _StoriesList(
                  stories: widget.stories,
                  selectedChapter: _currentChapter,
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
                top: 5,
                right: 10,
                child: _PropertiesContainer(
                  currentChapter: _currentChapter,
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
            if (_currentChapter?.codeLink != null)
              Positioned(
                top: _rightIconTop(_rightIconIndex++),
                right: 10,
                child: GestureDetector(
                  child: Icon(Icons.code),
                  onTap: () => _launchURL(_currentChapter.codeLink),
                ),
              ),
            if (_hasProperties())
              Positioned(
                top: _rightIconTop(_rightIconIndex++),
                right: 10,
                child: GestureDetector(
                  child: Icon(Icons.mode_edit),
                  onTap: () => setState(() => _isPropertiesOpen = true),
                ),
              ),
          ],
        );
      },
    );
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
        child: Text(
          this.label,
          textAlign: textAlign,
          style: textStyle,
        ),
      ),
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
      Text(
        'Stories',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
      ),
      SizedBox(height: 10),
    ];

    stories.forEach((story) {
      children.add(
        Text(
          story.name,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      );
      children.add(SizedBox(height: 10));

      story.chapters.forEach((chapter) {
        children.add(
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            child: _Link(
              label: "  ${chapter.name}",
              textAlign: TextAlign.left,
              padding: EdgeInsets.zero,
              height: 20,
              textStyle: TextStyle(
                fontWeight: chapter.id == selectedChapter.id
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
            onTap: () {
              onSelectChapter(chapter);
            },
          ),
        );
      });
    });

    return SingleChildScrollView(
      child: Container(
        color: Theme.of(context).cardColor,
        width: 300,
        child: Padding(
          padding: EdgeInsets.all(5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: children,
          ),
        ),
      ),
    );
  }
}

typedef OnPropertyChange = void Function();

class _PropertiesContainer extends StatefulWidget {
  final Chapter currentChapter;
  final OnPropertyChange onPropertyChange;

  _PropertiesContainer({this.currentChapter, this.onPropertyChange});

  @override
  State createState() => _PropertiesContainerState();
}

class _PropertiesContainerState extends State<_PropertiesContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // TODO media query
      width: 300,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10),
            Text(
              "Properties",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
          ]..addAll(
              widget.currentChapter.ctx.properties.entries.map((entry) {
                final _propertyKey =
                    Key("${widget.currentChapter.id}#${entry.value.name}");
                final _onChanged = (chapter) {
                  setState(() {});
                  if (widget.onPropertyChange != null) {
                    widget.onPropertyChange();
                  }
                };
                if (entry.value is ListProperty) {
                  return p.ListPropertyWidget(
                    property: entry.value,
                    onChanged: _onChanged,
                    key: _propertyKey,
                  );
                } else if (entry.value is Property<String>) {
                  return p.TextProperty(
                    property: entry.value,
                    onChanged: _onChanged,
                    key: _propertyKey,
                  );
                } else if (entry.value is Property<double>) {
                  return p.NumberProperty(
                    property: entry.value,
                    onChanged: _onChanged,
                    key: _propertyKey,
                  );
                } else if (entry.value is Property<bool>) {
                  return p.BoolProperty(
                    property: entry.value,
                    onChanged: _onChanged,
                    key: _propertyKey,
                  );
                } else if (entry.value is Property<Color>) {
                  return p.ColorProperty(
                    property: entry.value,
                    onChanged: _onChanged,
                    key: _propertyKey,
                  );
                } else if (entry.value is Property<EdgeInsets>) {
                  return p.EdgeInsetsProperty(
                    property: entry.value,
                    onChanged: _onChanged,
                    key: _propertyKey,
                  );
                } else if (entry.value is Property<BorderRadius>) {
                  return p.BorderRadiusProperty(
                    property: entry.value,
                    onChanged: _onChanged,
                    key: _propertyKey,
                  );
                }
                return Container();
              }),
            ),
        ),
      ),
    );
  }
}
