import 'package:flutter/material.dart';

import '../core/constants/admin.dart';
import 'di/app_dependencies.dart';
import 'router/app_router.dart';
import 'router/app_routes.dart';
import 'theme/app_theme.dart';

class App extends StatelessWidget {
  const App({super.key, required this.dependencies});

  final AppDependencies dependencies;

  @override
  Widget build(BuildContext context) {
    final appRouter = AppRouter(dependencies: dependencies);

    final isLoggedIn = dependencies.isUserLoggedIn();
    String initialRoute;
    if (isLoggedIn) {
      final user = dependencies.getCurrentAuthUser();
      if (AdminConstants.isAdmin(user?.email)) {
        initialRoute = AppRoutes.adminDashboard;
      } else {
        initialRoute = AppRoutes.home;
      }
    } else {
      initialRoute = AppRoutes.login;
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Roomix',
      theme: AppTheme.dark,
      initialRoute: initialRoute,
      onGenerateRoute: appRouter.onGenerateRoute,
    );
  }
}
