import 'package:e_commerce/core/navigation/app_routes.dart';
import 'package:e_commerce/core/services/service_locator.dart';
import 'package:e_commerce/features/auth/data/repositories/auth_repository.dart';
import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await configureDependencies();

  final isLoggedIn = await getIt<AuthRepository>().isLoggedIn();

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.isLoggedIn});

  final bool isLoggedIn;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-Commerce',
      theme: AppTheme.light,
      initialRoute: '/',
      onGenerateRoute: (settings) =>
          AppRoutes.onGenerateRoute(settings, isLoggedIn: isLoggedIn),
      debugShowCheckedModeBanner: false,
    );
  }
}
