import 'package:flutter/material.dart';

import '../../features/admin/presentation/pages/admin_dashboard_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/signup_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/matching/presentation/pages/match_results_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/requests/presentation/pages/requests_page.dart';
import '../../features/seats/presentation/pages/my_seats_page.dart';
import '../../features/seats/presentation/pages/seat_form_page.dart';
import '../../features/seats/presentation/pages/seat_search_page.dart';
import '../../features/admin/presentation/pages/admin_users_page.dart';
import '../../features/ratings/presentation/pages/submit_review_page.dart';
import '../../features/seats_applications/presentation/pages/applications_page.dart';
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
      case AppRoutes.mySeats:
        return RouteTransition.fadeSlide(
          MySeatsPage(
            getMySeats: dependencies.getMySeats,
            deleteSeat: dependencies.deleteSeat,
            updateSeat: dependencies.updateSeat,
          ),
          settings,
        );
      case AppRoutes.seatForm:
        return RouteTransition.fadeSlide(
          SeatFormPage(
            createSeat: dependencies.createSeat,
            updateSeat: dependencies.updateSeat,
          ),
          settings,
        );
      case AppRoutes.seatSearch:
        return RouteTransition.fadeSlide(
          SeatSearchPage(
            getAvailableSeats: dependencies.getAvailableSeats,
            applyForSeat: dependencies.applyForSeat,
            getOccupants: dependencies.getOccupants,
          ),
          settings,
        );
      case AppRoutes.adminUsers:
        return RouteTransition.fadeSlide(
          AdminUsersPage(
            adminRemoteDataSource: dependencies.adminRemoteDataSource,
          ),
          settings,
        );
      case AppRoutes.submitReview:
        final args = settings.arguments as Map<String, dynamic>?;
        final revieweeId = args?['revieweeId'] as String? ?? '';
        final revieweeName = args?['revieweeName'] as String? ?? '';
        return RouteTransition.fadeSlide(
          SubmitReviewPage(
            revieweeId: revieweeId,
            revieweeName: revieweeName,
            submitRating: dependencies.submitRating,
          ),
          settings,
        );
      case AppRoutes.applications:
        return RouteTransition.fadeSlide(
          ApplicationsPage(
            getApplications: dependencies.getApplications,
            respondToApplication: dependencies.respondToApplication,
          ),
          settings,
        );
      case AppRoutes.adminDashboard:
        return RouteTransition.fadeSlide(
          AdminDashboardPage(
            signOutUser: dependencies.signOutUser,
            getCurrentAuthUser: dependencies.getCurrentAuthUser,
            adminRemoteDataSource: dependencies.adminRemoteDataSource,
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
