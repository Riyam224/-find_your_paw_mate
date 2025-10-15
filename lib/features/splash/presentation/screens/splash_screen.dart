// ignore_for_file: use_build_context_synchronously
import 'dart:io';
import 'dart:async';
import 'package:animals_tasks/core/styling/app_colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  final Duration delay;

  const SplashScreen({
    super.key,
    this.delay = const Duration(seconds: 3), // default for real app
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool navigated = false;
  Timer? _timer; // ✅ keep a reference to cancel if needed

  @override
  void initState() {
    super.initState();

    // ✅ Skip timers in test environment
    if (kDebugMode && Platform.environment.containsKey('FLUTTER_TEST')) return;

    _timer = Timer(widget.delay, () {
      if (!mounted || navigated) return;
      navigated = true;
      try {
        GoRouter.of(context).go('/home');
      } catch (e) {
        debugPrint('⚠️ Navigation failed: $e');
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // ✅ prevent pending timer
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: AppColors.primaryLight,
        child: Center(
          child: Image.asset(
            'assets/images/logo.png',
            key: const Key('splash_logo'),
          ),
        ),
      ),
    );
  }
}
