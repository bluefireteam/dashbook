import 'package:dashbook/src/multi_brand_dashbook/dashbook_brand.dart';
import 'package:dashbook/src/multi_brand_dashbook/multi_brand_dashbook.dart';
import 'package:flutter/material.dart';

class SmallApp extends StatefulWidget {
  const SmallApp({
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
  State<SmallApp> createState() => _SmallAppState();
}

class _SmallAppState extends State<SmallApp>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      vsync: this,
      length: widget.brands.length,
      initialIndex: widget.selectedIndex,
    );
    _tabController.addListener(() {
      widget.onSelected(_tabController.index);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: widget.contentBuilder(context),
          ),
          TabBar(
            controller: _tabController,
            tabs: widget.brands.map((brand) => brand.icon).toList(),
          ),
        ],
      ),
    );
  }
}
