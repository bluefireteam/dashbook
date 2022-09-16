import 'package:dashbook/dashbook.dart';
import 'package:dashbook/src/dashbook_config.dart';
import 'package:dashbook/src/multi_brand_dashbook/dashbook_brand.dart';
import 'package:dashbook/src/multi_brand_dashbook/small_app.dart';
import 'package:dashbook/src/multi_brand_dashbook/wide_app.dart';
import 'package:dashbook/src/preferences.dart';
import 'package:dashbook/src/widgets/dashbook_content.dart';
import 'package:dashbook/src/widgets/widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

typedef OnSelectedIndexCallback = void Function(int index);
typedef ContentBuilder = Widget Function(BuildContext context);

class MultiBrandBookBuilder {
  final List<Story> _stories = [];
  final List<DashbookBrand> brands;

  MultiBrandBookBuilder({required this.brands});

  Story storiesOf(String name) {
    final story = Story(name);
    _stories.add(story);

    return story;
  }

  Widget build() {
    return MultiBrandApp(
      brands: brands,
      config: DashbookConfig(
        usePreviewSafeArea: true,
        autoPinStoriesOnLargeScreen: true,
        preferences: DashbookPreferences(),
        title: 'Dashbook',
        stories: _stories,
      ),
    );
  }
}

class MultiBrandApp extends StatelessWidget {
  MultiBrandApp({
    required this.brands,
    required this.config,
    Key? key,
  }) : super(key: key);
  final List<DashbookBrand> brands;
  final DashbookConfig config;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routeInformationProvider: _router.routeInformationProvider,
      routeInformationParser: _router.routeInformationParser,
      routerDelegate: _router.routerDelegate,
      title: 'GoRouter Example',
    );
  }

  late final GoRouter _router = _createRouter();

  GoRouter _createRouter() {
    final routes = brands
        .map(
          (e) => GoRoute(
            path: '/${e.path}',
            pageBuilder: (context, state) => CustomTransitionPage<void>(
              key: state.pageKey,
              child: MultiBrandDashbook(
                brands: brands,
                selectedBrand: e,
                config: config,
              ),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) =>
                      FadeTransition(opacity: animation, child: child),
            ),
          ),
        )
        .toList();

    return GoRouter(
      routes: routes,
      redirect: (state) => state.path == '/' ? '/${brands.first.path}' : null,
    );
  }
}

class MultiBrandDashbook extends StatefulWidget {
  const MultiBrandDashbook({
    required this.brands,
    required this.config,
    required this.selectedBrand,
    Key? key,
  }) : super(key: key);
  final List<DashbookBrand> brands;
  final DashbookConfig config;
  final DashbookBrand selectedBrand;

  @override
  State<MultiBrandDashbook> createState() => _MultiBrandDashbookState();
}

class _MultiBrandDashbookState extends State<MultiBrandDashbook> {
  List<ThemeSettings> get themeSettings =>
      widget.brands.map((e) => e.themeSettings).toList();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final content = screenWidth > 500
        ? WideApp(
            brands: widget.brands,
            selectedIndex: widget.brands.indexOf(widget.selectedBrand),
            onSelected: (i) => context.go('/${widget.brands[i].path}'),
            contentBuilder: builder,
          )
        : SmallApp(
            brands: widget.brands,
            selectedIndex: widget.brands.indexOf(widget.selectedBrand),
            onSelected: (i) => context.go('/${widget.brands[i].path}'),
            contentBuilder: builder,
          );
    return Theme(
      data: widget.selectedBrand.themeSettings.currentTheme,
      child: content,
    );
  }

  Widget builder(BuildContext context) {
    return _MultiBrandContent(
      config: widget.config,
      stories: widget.config.stories,
      themeSettings: widget.selectedBrand.themeSettings,
      onThemeChange: (themeData) {
        setState(() {
          widget.selectedBrand.themeSettings.currentTheme = themeData;
        });
      },
    );
  }
}

class _MultiBrandContent extends StatefulWidget {
  const _MultiBrandContent({
    Key? key,
    required this.config,
    required this.themeSettings,
    required this.onThemeChange,
    required this.stories,
  }) : super(key: key);
  final DashbookConfig config;
  final ThemeSettings themeSettings;
  final OnThemeChange onThemeChange;
  final List<Story> stories;

  @override
  State<_MultiBrandContent> createState() => _MultiBrandContentState();
}

class _MultiBrandContentState extends State<_MultiBrandContent> {
  CurrentView? currentView = CurrentView.stories;
  Chapter? currentChapter;

  @override
  void initState() {
    super.initState();
    currentChapter = widget.stories.first.chapters.first;
  }

  @override
  Widget build(BuildContext context) {
    return DashbookContent(
      currentView: currentView,
      currentChapter: currentChapter,
      config: widget.config,
      onChapterChange: onChapterChange,
      onViewChange: onViewChange,
      themeSettings: widget.themeSettings,
      onThemeChange: widget.onThemeChange,
    );
  }

  void onChapterChange(Chapter chapter) {
    setState(() {
      currentChapter = chapter;
    });
  }

  void onViewChange(CurrentView? view) {
    setState(() {
      currentView = view;
    });
  }
}
