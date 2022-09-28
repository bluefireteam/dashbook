import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

import './story.dart';
import 'property_widgets/properties.dart' as p;

class Dashbook extends StatelessWidget {
  final List<Story> stories = [];
  final ThemeData? theme;

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
        '/': (BuildContext context) {
          bool isLargeScreen = MediaQuery.of(context).size.width > 768;
          return Scaffold(
            body: SafeArea(
              child: isLargeScreen
                  ? _DashbookBodyWeb(stories: stories)
                  : _DashbookBodyMobile(
                      stories: stories,
                    ),
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

class _DashbookBodyWeb extends StatefulWidget {
  final List<Story>? stories;

  _DashbookBodyWeb({this.stories});

  @override
  State createState() => _DashbookBodyWebState();
}

class _DashbookBodyWebState extends State<_DashbookBodyWeb> {
  Chapter? _currentChapter;
  bool _isStoriesOpen = false;

  @override
  void initState() {
    super.initState();

    if (widget.stories!.isNotEmpty) {
      final story = widget.stories!.first;

      if (story.chapters.isNotEmpty) {
        _currentChapter = story.chapters.first;
      }
    }
  }

  bool _hasProperties() => _currentChapter!.ctx.properties.isNotEmpty;

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
        final chapterWidget = _currentChapter?.widget(constraints);
        final preview = _ChapterIconsOverlay(
          child: chapterWidget,
          codeLink: _currentChapter!.codeLink,
        );

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
                            top: BorderSide(color: Theme.of(context).dividerColor),
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
              flex: _isStoriesOpen ? 2 : 1,
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
  final List<Story>? stories;

  _DashbookBodyMobile({this.stories});

  @override
  State createState() => _DashbookBodyMobileState();
}

class _DashbookBodyMobileState extends State<_DashbookBodyMobile> {
  CurrentView? _currentView;
  Chapter? _currentChapter;

  @override
  void initState() {
    super.initState();

    if (widget.stories!.isNotEmpty) {
      final story = widget.stories!.first;
      _currentView = CurrentView.STORIES;

      if (story.chapters.isNotEmpty) {
        _currentChapter = story.chapters.first;
        _currentView = CurrentView.CHAPTER;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget? view;
    if (_currentView == CurrentView.CHAPTER) {
      view = _currentChapter != null
          ? _ChapterPreview(
              currentChapter: _currentChapter,
              key: Key(_currentChapter!.id),
            )
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
      Expanded(child: view!),
      Container(
        height: 50,
        child: Row(
          children: [
            Expanded(
              child: _Link(
                label: 'Stories',
                textAlign: TextAlign.center,
                textStyle: TextStyle(
                  fontWeight: _currentView == CurrentView.STORIES ? FontWeight.bold : FontWeight.normal,
                ),
                onTap: () {
                  setState(() {
                    _currentView = CurrentView.STORIES;
                  });
                },
              ),
            ),
            Expanded(
              child: _Link(
                label: 'Preview',
                textAlign: TextAlign.center,
                textStyle: TextStyle(
                  fontWeight: _currentView == CurrentView.CHAPTER ? FontWeight.bold : FontWeight.normal,
                ),
                onTap: () {
                  setState(() {
                    _currentView = CurrentView.CHAPTER;
                  });
                },
              ),
            ),
            Expanded(
              child: _Link(
                label: 'Properties',
                textAlign: TextAlign.center,
                textStyle: TextStyle(
                  fontWeight: _currentView == CurrentView.PROPERTIES ? FontWeight.bold : FontWeight.normal,
                ),
                onTap: () {
                  setState(() {
                    _currentView = CurrentView.PROPERTIES;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    ]);
  }
}

class _Link extends StatelessWidget {
  final String? label;
  final TextStyle? textStyle;
  final void Function()? onTap;
  final TextAlign? textAlign;
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
          this.label!,
          textAlign: textAlign,
          style: textStyle,
        ),
      ),
      onTap: onTap,
    );
  }
}

class _StoriesList extends StatelessWidget {
  final List<Story>? stories;
  final Chapter? selectedChapter;
  final OnSelectChapter? onSelectChapter;

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

    stories!.forEach((story) {
      children.add(
        ExpansionTile(
          title: Text(
            story.name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.black,
            ),
          ),
          children: story.chapters
              .map((chapter) => GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 2, 16, 8),
                        child: _Link(
                          label: "  ${chapter.name}",
                          textAlign: TextAlign.left,
                          padding: EdgeInsets.zero,
                          height: 20,
                          textStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: chapter.id == selectedChapter!.id ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                    onTap: () {
                      onSelectChapter!(chapter);
                    },
                  ))
              .toList(),
        ),
      );
    });

    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent,
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.black),
      ),
      child: SingleChildScrollView(
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

class _ChapterPreview extends StatelessWidget {
  final Chapter? currentChapter;

  _ChapterPreview({this.currentChapter, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext ctx) {
    return LayoutBuilder(
      builder: (_, constraints) {
        final child = currentChapter!.widget(constraints);

        return _ChapterIconsOverlay(
          child: child,
          codeLink: currentChapter!.codeLink,
        );
      },
    );
  }
}

class _ChapterIconsOverlay extends StatelessWidget {
  final Widget? child;
  final String? codeLink;

  _ChapterIconsOverlay({
    this.child,
    this.codeLink,
  });

  @override
  Widget build(_) {
    if (codeLink != null) {
      return Stack(
        children: [
          Positioned.fill(child: child!),
          Positioned(
            top: 10,
            right: 10,
            child: GestureDetector(
              child: Icon(Icons.code),
              onTap: () => _launchURL(codeLink!),
            ),
          ),
        ],
      );
    }

    return child!;
  }

  Future<void> _launchURL(String url) async {
    if (await url_launcher.canLaunch(url)) {
      await url_launcher.launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

typedef OnPropertyChange = void Function();

class _PropertiesContainer extends StatefulWidget {
  final Chapter? currentChapter;
  final OnPropertyChange? onPropertyChange;

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
            widget.currentChapter!.ctx.properties.entries.map((entry) {
              final _propertyKey = Key("${widget.currentChapter!.id}#${entry.value.name}");
              final _onChanged = (chapter) {
                setState(() {});
                if (widget.onPropertyChange != null) {
                  widget.onPropertyChange!();
                }
              };
              if (entry.value is ListProperty) {
                return p.ListPropertyWidget(
                  property: entry.value as ListProperty?,
                  onChanged: _onChanged,
                  key: _propertyKey,
                );
              } else if (entry.value is Property<String>) {
                return p.TextProperty(
                  property: entry.value as Property<String?>?,
                  onChanged: _onChanged,
                  key: _propertyKey,
                );
              } else if (entry.value is Property<double>) {
                return p.NumberProperty(
                  property: entry.value as Property<double?>?,
                  onChanged: _onChanged,
                  key: _propertyKey,
                );
              } else if (entry.value is Property<bool>) {
                return p.BoolProperty(
                  property: entry.value as Property<bool?>?,
                  onChanged: _onChanged,
                  key: _propertyKey,
                );
              } else if (entry.value is Property<Color>) {
                return p.ColorProperty(
                  property: entry.value as Property<Color?>?,
                  onChanged: _onChanged,
                  key: _propertyKey,
                );
              } else if (entry.value is Property<EdgeInsets>) {
                return p.EdgeInsetsProperty(
                  property: entry.value as Property<EdgeInsets?>?,
                  onChanged: _onChanged,
                  key: _propertyKey,
                );
              } else if (entry.value is Property<BorderRadius>) {
                return p.BorderRadiusProperty(
                  property: entry.value as Property<BorderRadius?>?,
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
