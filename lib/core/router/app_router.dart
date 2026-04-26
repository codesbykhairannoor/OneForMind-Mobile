import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/register_screen.dart';
import '../../features/auth/presentation/onboarding_screen.dart';
import '../../features/dashboard/presentation/dashboard_screen.dart';
import '../../features/dashboard/presentation/nexus_screen.dart';
import '../../features/coach/presentation/coach_screen.dart';
import '../layout/main_layout.dart';

part 'app_router.g.dart';

@riverpod
GoRouter appRouter(AppRouterRef ref) {
  return GoRouter(
    initialLocation: '/login',
    debugLogDiagnostics: true,
    routes: [
      // Auth Routes
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),

      // Shell Route for Main App Features
      ShellRoute(
        builder: (context, state, child) => MainLayout(child: child),
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: '/planner',
            builder: (context, state) => const Center(child: Text('Planner Screen')),
          ),
          GoRoute(
            path: '/finance',
            builder: (context, state) => const Center(child: Text('Finance Screen')),
          ),
          GoRoute(
            path: '/nexus',
            builder: (context, state) => const NexusScreen(),
          ),
          GoRoute(
            path: '/coach',
            builder: (context, state) => const CoachScreen(),
          ),
        ],
      ),
    ],
  );
}
