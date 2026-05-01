import 'package:flutter/material.dart';

import '../../features/admin/presentation/pages/admin_dashboard_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/signup_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/matching/presentation/pages/match_results_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/requests/presentation/pages/requests_page.dart';
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
          LoginPage(
            signInWithEmail: dependencies.signInWithEmail,
            getCurrentAuthUser: dependencies.getCurrentAuthUser,
          ),
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
            getCurrentAuthUser: dependencies.getCurrentAuthUser,
          ),
          settings,
        );
      case AppRoutes.profile:
        return RouteTransition.fadeSlide(
          ProfilePage(
            getCurrentAuthUser: dependencies.getCurrentAuthUser,
            getMyProfile: dependencies.getMyProfile,
            upsertMyProfile: dependencies.upsertMyProfile,
            getMyPreferences: dependencies.getMyPreferences,
            upsertMyPreferences: dependencies.upsertMyPreferences,
          ),
          settings,
        );
      case AppRoutes.matchResults:
        return RouteTransition.fadeSlide(
          MatchResultsPage(
            getMatchSuggestions: dependencies.getMatchSuggestions,
            sendRoommateRequest: dependencies.sendRoommateRequest,
            getMyRequests: dependencies.getMyRequests,
          ),
          settings,
        );
      case AppRoutes.requests:
        return RouteTransition.fadeSlide(
          RequestsPage(
            getMyRequests: dependencies.getMyRequests,
            respondToRequest: dependencies.respondToRequest,
          ),
          settings,
        );
      case AppRoutes.adminDashboard:
        return RouteTransition.fadeSlide(
          AdminDashboardPage(
            signOutUser: dependencies.signOutUser,
            getCurrentAuthUser: dependencies.getCurrentAuthUser,
          ),
          settings,
        );
      default:
        return RouteTransition.fadeSlide(
          LoginPage(
            signInWithEmail: dependencies.signInWithEmail,
            getCurrentAuthUser: dependencies.getCurrentAuthUser,
          ),
          settings,
        );
    }
  }
}
