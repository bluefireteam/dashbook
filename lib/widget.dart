import 'package:dashbook/properties_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import './story.dart';
import 'property_widgets/properties.dart' as p;

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
      theme: theme,
      routes: {
        '/': (BuildContext context) => Scaffold(
              body: SafeArea(
                child: kIsWeb
                    ? _DashbookBodyWeb(stories: stories)
                    : _DashbookBodyMobile(
                        stories: stories,
                      ),
              ),
            ),
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

class _DashbookBodyWeb extends StatefulWidget {
  final List<Story> stories;

  _DashbookBodyWeb({this.stories});

  @override
  State createState() => _DashbookBodyWebState();
}

class _DashbookBodyWebState extends State<_DashbookBodyWeb> {
  Chapter _currentChapter;
  bool _isStoriesOpen = false;

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

  void _toggleStoriesList() {
    setState(() {
      _isStoriesOpen = !_isStoriesOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        Widget body;
        Widget preview = _currentChapter?.widget(constraints);

        if (_hasProperties()) {
          body = Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 10,
                child: preview,
              ),
              Expanded(
                flex: 4,
                child: !_hasProperties()
                    ? Container()
                    : Container(
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                                color: Theme.of(context).dividerColor),
                          ),
                        ),
                        child: _PropertiesContainer(
                          currentChapter: _currentChapter,
                          onPropertyChange: () {
                            setState(() {});
                          },
                        ),
                      ),
              ),
            ],
          );
        } else {
          body = preview;
        }

        final storiesWidget = _StoriesList(
          stories: widget.stories,
          selectedChapter: _currentChapter,
          onSelectChapter: (chapter) {
            setState(() {
              _currentChapter = chapter;
            });
          },
        );

        final _storiesStackList = <Widget>[];

        if (_isStoriesOpen) {
          _storiesStackList.add(
            Positioned.fill(child: storiesWidget),
          );
        }

        _storiesStackList.add(
          Positioned(
            top: 5,
            right: 10,
            child: GestureDetector(
              child: Icon(
                _isStoriesOpen ? Icons.navigate_before : Icons.navigate_next,
              ),
              onTap: _toggleStoriesList,
            ),
          ),
        );

        return Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: _isStoriesOpen ? 2 : null,
              child: Container(
                width: _isStoriesOpen ? null : 45,
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(color: Theme.of(context).dividerColor),
                  ),
                ),
                child: Stack(children: _storiesStackList),
              ),
            ),
            Expanded(
              flex: 8,
              child: body,
            ),
          ],
        );
      },
    );
  }
}

class _DashbookBodyMobile extends StatefulWidget {
  final List<Story> stories;

  _DashbookBodyMobile({this.stories});

  @override
  State createState() => _DashbookBodyMobileState();
}

class _DashbookBodyMobileState extends State<_DashbookBodyMobile> {
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

  @override
  Widget build(BuildContext context) {
    Widget view;

    view = _StoriesList(
      stories: widget.stories,
      selectedChapter: _currentChapter,
      onSelectChapter: (chapter) {
        setState(() {
          _currentChapter = chapter;
        });
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PropertiesPage(chapter),
          ),
        );
      },
    );

    return Column(children: [
      Expanded(child: view),
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
      child: Padding(
        padding: EdgeInsets.all(5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: children,
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
    return SingleChildScrollView(
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
    );
  }
}
