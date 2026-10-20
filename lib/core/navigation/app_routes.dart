import 'package:e_commerce/core/widgets/main_bottom_navigation.dart';
import 'package:flutter/material.dart';

import 'main_navigation_view.dart';
import '../../features/auth/presentation/views/login.dart';
import '../../features/products/presentation/views/favorites_view.dart';
import '../../features/products/presentation/views/offers_view.dart';
import '../../features/products/presentation/views/product_details_view.dart';

class AppRoutes {
  AppRoutes._();

  static const String login = '/login';
  static const String products = '/products';
  static const String productDetails = '/product-details';
  static const String favorites = '/favorites';
  static const String offers = '/offers';
  static const String explore = '/explore';

  static Route<dynamic> onGenerateRoute(
    RouteSettings settings, {
    required bool isLoggedIn,
  }) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute<void>(
          builder: (_) => const LoginView(),
          settings: settings,
        );

      case products:
        return MaterialPageRoute<void>(
          builder: (_) => const MainNavigationView(),
          settings: settings,
        );

      case login:
        return MaterialPageRoute<void>(
          builder: (_) => const LoginView(),
          settings: settings,
        );

      case favorites:
        return MaterialPageRoute<void>(
          builder: (_) => const FavoritesView(),
          settings: settings,
        );

      case offers:
        return MaterialPageRoute<void>(
          builder: (_) => const OffersView(),
          settings: settings,
        );

      case explore:
        return MaterialPageRoute<void>(
          builder: (_) => isLoggedIn
              ? const MainNavigationView(initialTab: MainTab.explore)
              : const LoginView(),
          settings: settings,
        );

      case productDetails:
        final productId = settings.arguments;

        if (productId is! String || productId.isEmpty) {
          return _errorRoute('A valid product ID is required.');
        }

        return MaterialPageRoute<void>(
          builder: (_) => ProductDetailsView(productId: productId),
          settings: settings,
        );

      default:
        return _errorRoute('Page not found: ${settings.name}');
    }
  }

  static MaterialPageRoute<void> _errorRoute(String message) {
    return MaterialPageRoute<void>(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('Navigation Error')),
        body: Center(child: Text(message)),
      ),
    );
  }
}
