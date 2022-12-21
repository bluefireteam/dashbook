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
typedef MaterialAppBuilder = Widget Function({
  RouteInformationProvider? routeInformationProvider,
  RouteInformationParser<Object>? routeInformationParser,
  RouterDelegate<Object>? routerDelegate,
});

class MultiBrandBookBuilder {
  final List<Story> _stories = [];
  final List<DashbookBrand> brands;
  final String title;
  final MaterialAppBuilder? appBuilder;

  MultiBrandBookBuilder({
    required this.brands,
    required this.title,
    this.appBuilder,
  });

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
        title: title,
        stories: _stories,
      ),
      appBuilder: appBuilder,
    );
  }
}

class MultiBrandApp extends StatelessWidget {
  MultiBrandApp({
    required this.brands,
    required this.config,
    this.appBuilder,
    Key? key,
  }) : super(key: key);
  final List<DashbookBrand> brands;
  final DashbookConfig config;
  final MaterialAppBuilder? appBuilder;

  @override
  Widget build(BuildContext context) {
    return appBuilder?.call(
          routeInformationProvider: _router.routeInformationProvider,
          routeInformationParser: _router.routeInformationParser,
          routerDelegate: _router.routerDelegate,
        ) ??
        MaterialApp.router(
          routeInformationProvider: _router.routeInformationProvider,
          routeInformationParser: _router.routeInformationParser,
          routerDelegate: _router.routerDelegate,
          title: config.title,
        );
  }

  late final GoRouter _router = _createRouter();

  GoRouter _createRouter() {
    final routes = GoRoute(
      path: '/:brand/:story/:chapter',
      pageBuilder: (context, state) {
        return CustomTransitionPage<void>(
          key: state.pageKey,
          child: MultiBrandDashbook(
            brands: brands,
            selectedBrand: brands.firstWhere(
              (element) => element.path == state.params['brand'],
            ),
            currentChapter:
                getChapter(state.params['story']!, state.params['chapter']!),
            config: config,
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(opacity: animation, child: child),
        );
      },
    );

    return GoRouter(
      initialLocation:
          '/${brands.first.path}/${config.stories.first.path}/${config.stories.first.chapters.first.path}',
      routes: [routes],
    );
  }

  Chapter getChapter(String story, String chapter) {
    return config.stories
        .firstWhere((element) => element.path == story)
        .chapters
        .firstWhere((element) => element.path == chapter);
  }
}

class MultiBrandDashbook extends StatefulWidget {
  const MultiBrandDashbook({
    required this.brands,
    required this.config,
    required this.selectedBrand,
    required this.currentChapter,
    Key? key,
  }) : super(key: key);
  final List<DashbookBrand> brands;
  final DashbookConfig config;
  final DashbookBrand selectedBrand;
  final Chapter currentChapter;

  @override
  State<MultiBrandDashbook> createState() => _MultiBrandDashbookState();
}

class _MultiBrandDashbookState extends State<MultiBrandDashbook> {
  List<ThemeSettings> get themeSettings =>
      widget.brands.map((e) => e.themeSettings).toList();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return screenWidth > 500
        ? WideApp(
            brands: widget.brands,
            selectedIndex: widget.brands.indexOf(widget.selectedBrand),
            onSelected: (i) => _navigate(brand: widget.brands[i].path),
            contentBuilder: builder,
          )
        : SmallApp(
            brands: widget.brands,
            selectedIndex: widget.brands.indexOf(widget.selectedBrand),
            onSelected: (i) => _navigate(brand: widget.brands[i].path),
            contentBuilder: builder,
          );
  }

  void _navigate({String? brand, Chapter? chapter}) {
    brand ??= widget.selectedBrand.path;
    chapter ??= widget.currentChapter;
    context.go(
      '/$brand/${chapter.story.path}/${chapter.path}',
    );
  }

  Widget builder(BuildContext context) {
    return _MultiBrandContent(
      brand: widget.selectedBrand,
      config: widget.config,
      stories: widget.config.stories,
      themeSettings: widget.selectedBrand.themeSettings,
      onThemeChange: (themeData) {
        setState(() {
          widget.selectedBrand.themeSettings.currentTheme = themeData;
        });
      },
      currentChapter: widget.currentChapter,
      onChapterChange: (chapter) => _navigate(chapter: chapter),
    );
  }
}

class _MultiBrandContent extends StatefulWidget {
  const _MultiBrandContent({
    required this.brand,
    required this.config,
    required this.themeSettings,
    required this.onThemeChange,
    required this.stories,
    required this.currentChapter,
    required this.onChapterChange,
    Key? key,
  }) : super(key: key);
  final DashbookBrand brand;
  final DashbookConfig config;
  final ThemeSettings themeSettings;
  final OnThemeChange onThemeChange;
  final List<Story> stories;
  final Chapter currentChapter;
  final OnChapterChange onChapterChange;

  @override
  State<_MultiBrandContent> createState() => _MultiBrandContentState();
}

class _MultiBrandContentState extends State<_MultiBrandContent> {
  CurrentView? currentView = CurrentView.stories;

  @override
  Widget build(BuildContext context) {
    return DashbookContent(
      brand: widget.brand,
      currentView: currentView,
      currentChapter: widget.currentChapter,
      config: widget.config,
      onChapterChange: widget.onChapterChange,
      onViewChange: onViewChange,
      themeSettings: widget.themeSettings,
      onThemeChange: widget.onThemeChange,
    );
  }

  void onViewChange(CurrentView? view) {
    setState(() {
      currentView = view;
    });
  }
}
