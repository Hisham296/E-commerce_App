import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

enum MainTab { home, explore, cart, offer, account }

class MainBottomNavigation extends StatelessWidget {
  final MainTab selectedTab;
  final ValueChanged<MainTab> onTabSelected;

  const MainBottomNavigation({
    super.key,
    required this.selectedTab,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    const tabs = [
      _TabItem(MainTab.home, Icons.home_outlined, 'Home'),
      _TabItem(MainTab.explore, Icons.search, 'Explore'),
      _TabItem(MainTab.cart, Icons.shopping_cart_outlined, 'Cart'),
      _TabItem(MainTab.offer, Icons.local_offer_outlined, 'Offer'),
      _TabItem(MainTab.account, Icons.person_outline, 'Account'),
    ];

    return BottomNavigationBar(
      currentIndex: selectedTab.index,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.textSecondary,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      selectedFontSize: 12,
      unselectedFontSize: 12,
      elevation: 8,
      onTap: (index) => onTabSelected(tabs[index].tab),
      items: tabs
          .map(
            (tab) =>
                BottomNavigationBarItem(icon: Icon(tab.icon), label: tab.label),
          )
          .toList(),
    );
  }
}

class _TabItem {
  final MainTab tab;
  final IconData icon;
  final String label;

  const _TabItem(this.tab, this.icon, this.label);
}
