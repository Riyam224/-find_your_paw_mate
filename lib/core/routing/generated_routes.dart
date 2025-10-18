import 'package:animals_tasks/core/routing/app_routes.dart';
import 'package:animals_tasks/features/details/presentation/screens/details_screen.dart';
import 'package:animals_tasks/features/favorite/presentation/screens/favorite_screen.dart';

import 'package:animals_tasks/features/home/presentation/screens/home_screen.dart';
import 'package:animals_tasks/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:animals_tasks/features/splash/presentation/screens/splash_screen.dart';

import 'package:animals_tasks/layout/main_layout.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RouteGenerator {
  static GoRouter mainRoutingInOurApp = GoRouter(
    errorBuilder: (context, state) =>
        const Scaffold(body: Center(child: Text('404 Not Found'))),
    // todo initial route
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        name: AppRoutes.splash,
        builder: (context, state) =>   SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        name: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: AppRoutes.mainLayout,
        name: AppRoutes.mainLayout,
        builder: (context, state) => const MainLayout(),
      ),
      GoRoute(
        path: AppRoutes.home,
        name: AppRoutes.home,
        builder: (context, state) => const HomeScreen(),
      ),

      GoRoute(
        path: AppRoutes.details,
        name: AppRoutes.details,
        builder: (context, state) {
          final dogId = state.extra as String;
          return DetailsScreen(dogId: dogId);
        },
      ),
      GoRoute(
        path: AppRoutes.favorite,
        name: AppRoutes.favorite,
        builder: (context, state) {
          return FavoriteScreen();
        },
      ),
    ],
  );
}
