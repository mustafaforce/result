import 'package:flutter/material.dart';

import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/signup_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../di/app_dependencies.dart';
import 'app_routes.dart';
import 'route_transition.dart';

class AppRouter {
  const AppRouter({required this.dependencies});

  final AppDependencies dependencies;

  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.login:
        return RouteTransition.fadeSlide(
          LoginPage(signInWithEmail: dependencies.signInWithEmail),
          settings,
        );
      case AppRoutes.signUp:
        return RouteTransition.fadeSlide(
          SignUpPage(signUpWithEmail: dependencies.signUpWithEmail),
          settings,
        );
      case AppRoutes.home:
        return RouteTransition.fadeSlide(
          HomePage(
            signOutUser: dependencies.signOutUser,
            authRepository: dependencies.authRepository,
          ),
          settings,
        );
      default:
        return RouteTransition.fadeSlide(
          LoginPage(signInWithEmail: dependencies.signInWithEmail),
          settings,
        );
    }
  }
}
