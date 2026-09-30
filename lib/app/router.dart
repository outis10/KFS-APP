import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kfs/features/app_info/presentation/about_screen.dart';
import 'package:kfs/features/home/presentation/home_screen.dart';

/// Central route table. Auth and update gates (M1 #6, #7) plug in via
/// `redirect`.
final routerProvider = Provider<GoRouter>(
  (ref) => GoRouter(
    routes: [
      GoRoute(
        path: HomeScreen.routePath,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: AboutScreen.routePath,
        builder: (context, state) => const AboutScreen(),
      ),
    ],
  ),
);
