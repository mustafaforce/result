import 'package:flutter/material.dart';

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

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Roomix',
      theme: AppTheme.light,
      initialRoute: dependencies.authRepository.isLoggedIn
          ? AppRoutes.home
          : AppRoutes.login,
      onGenerateRoute: appRouter.onGenerateRoute,
    );
  }
}
