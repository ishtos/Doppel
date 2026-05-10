import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/feedback/presentation/screens/feedback_screen.dart';
import '../features/home/presentation/screens/home_screen.dart';
import '../features/lesson/presentation/screens/lesson_screen.dart';
import '../features/library/presentation/screens/library_screen.dart';
import '../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../features/splash/presentation/screens/splash_screen.dart';
import '../features/progress/presentation/screens/progress_screen.dart';
import '../features/settings/presentation/screens/about_screen.dart'; // FIXED: About画面import追加
import '../features/settings/presentation/screens/settings_screen.dart';
import '../features/settings/presentation/providers/settings_provider.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  final hasCompletedOnboarding = ref.watch(
    settingsProvider.select((s) => s.hasCompletedOnboarding),
  ); // FIXED: オンボーディング完了状態を監視

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/splash',
    redirect: (context, state) {
      if (state.uri.path == '/splash') return null;
      final isOnboarding = state.uri.path == '/onboarding';
      if (!hasCompletedOnboarding && !isOnboarding) {
        return '/onboarding';
      }
      if (hasCompletedOnboarding && isOnboarding) {
        return '/home';
      }
      return null;
    },
    routes: [
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(
            path: '/home',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: HomeScreen(),
            ),
          ),
          GoRoute(
            path: '/library',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: LibraryScreen(),
            ),
          ),
          GoRoute(
            path: '/progress',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ProgressScreen(),
            ),
          ),
        ],
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/lesson/:lessonId',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: LessonScreen(
            lessonId: state.pathParameters['lessonId']!,
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/feedback/:feedbackId',
        builder: (context, state) => FeedbackScreen(
          feedbackId: state.pathParameters['feedbackId']!,
        ),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/about',
        builder: (context, state) => const AboutScreen(),
      ),
    ],
  );
});

class MainShell extends StatelessWidget {
  const MainShell({super.key, required this.child});

  final Widget child;

  static const _tabs = ['/home', '/library', '/progress'];

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final index = _tabs.indexWhere((t) => location.startsWith(t));
    return index < 0 ? 0 : index;
  }

  @override
  Widget build(BuildContext context) {
    final index = _currentIndex(context);

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (i) => context.go(_tabs[i]),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'ホーム',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book),
            label: 'ライブラリ',
          ),
          NavigationDestination(
            icon: Icon(Icons.insights_outlined),
            selectedIcon: Icon(Icons.insights),
            label: '進捗',
          ),
        ],
      ),
    );
  }
}
