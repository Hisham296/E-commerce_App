import 'package:flutter/material.dart';

import '../../features/products/presentation/views/products_view.dart';
import '../../features/products/presentation/views/explore_view.dart';
import '../../features/products/presentation/views/offers_view.dart';
import '../widgets/main_bottom_navigation.dart';

class MainNavigationView extends StatefulWidget {
  final MainTab initialTab;

  const MainNavigationView({super.key, this.initialTab = MainTab.home});

  @override
  State<MainNavigationView> createState() => _MainNavigationViewState();
}

class _MainNavigationViewState extends State<MainNavigationView> {
  late MainTab _selectedTab;

  @override
  void initState() {
    super.initState();
    _selectedTab = widget.initialTab;
  }

  void _onTabSelected(MainTab tab) {
    if (tab == MainTab.cart || tab == MainTab.account) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            tab == MainTab.cart
                ? 'Cart screen is coming soon.'
                : 'Account screen is coming soon.',
          ),
        ),
      );
      return;
    }

    setState(() {
      _selectedTab = tab;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      const ProductsView(),
      const ExploreView(),
      const SizedBox.shrink(),
      const OffersView(),
      const SizedBox.shrink(),
    ];

    return Scaffold(
      body: IndexedStack(index: _selectedTab.index, children: pages),
      bottomNavigationBar: MainBottomNavigation(
        selectedTab: _selectedTab,
        onTabSelected: _onTabSelected,
      ),
    );
  }
}
