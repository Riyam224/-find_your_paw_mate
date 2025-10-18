import 'package:animals_tasks/core/di/di.dart';
import 'package:animals_tasks/core/routing/generated_routes.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // 💉 Initialize Dependency Injection (GetIt)
  await setupDependencies();
  runApp(const FindYourPawMate());
}

class FindYourPawMate extends StatelessWidget {
  const FindYourPawMate({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      // theme: AppThemes.lightTheme,
      routerConfig: RouteGenerator.mainRoutingInOurApp,
    );
  }
}
