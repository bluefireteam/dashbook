import 'package:dashbook/src/multi_brand_dashbook/dashbook_brand.dart';
import 'package:dashbook/src/multi_brand_dashbook/multi_brand_dashbook.dart';
import 'package:flutter/material.dart';

class WideApp extends StatelessWidget {
  const WideApp({
    required this.brands,
    required this.selectedIndex,
    required this.onSelected,
    required this.contentBuilder,
    Key? key,
  }) : super(key: key);
  final List<DashbookBrand> brands;
  final int selectedIndex;
  final OnSelectedIndexCallback onSelected;
  final ContentBuilder contentBuilder;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: <Widget>[
          NavigationRail(
            selectedIndex: selectedIndex,
            onDestinationSelected: onSelected,
            labelType: NavigationRailLabelType.none,
            useIndicator: true,
            indicatorColor: Colors.grey.shade300,
            destinations: createDestinations(context),
          ),
          const VerticalDivider(thickness: 1, width: 1),
          // This is the main content.
          Expanded(
            child: contentBuilder(context),
          ),
        ],
      ),
    );
  }

  List<NavigationRailDestination> createDestinations(BuildContext context) =>
      brands
          .map(
            (brand) => NavigationRailDestination(
              icon: brand.iconBuilder(context, ScreenSize.large),
              label: Text(brand.name),
            ),
          )
          .toList();
}
