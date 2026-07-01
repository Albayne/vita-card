import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'core/theme/app_theme.dart';
import 'features/onboarding/screens/splash_screen.dart';
import 'features/onboarding/screens/welcome_screen.dart';
import 'features/onboarding/screens/phone_verify_screen.dart';
import 'features/onboarding/screens/token_reveal_screen.dart';
import 'features/dashboard/screens/dashboard_screen.dart';
import 'features/health_fund/screens/fund_home_screen.dart';
import 'features/health_fund/screens/fund_calculator_screen.dart';
import 'features/health_fund/screens/fund_wallets_screen.dart';
import 'features/sti_reminder/screens/sti_home_screen.dart';
import 'features/sti_reminder/screens/sti_reminders_screen.dart';
import 'features/sti_reminder/screens/sti_log_screen.dart';
import 'features/mental_health/screens/mh_home_screen.dart';
import 'features/mental_health/screens/mh_book_screen.dart';
import 'features/mental_health/screens/mh_confirm_screen.dart';
import 'features/mental_health/screens/mh_mood_screen.dart';
import 'features/mental_health/models/counsellor_slot.dart';
import 'features/quitrr/screens/quitrr_home_screen.dart';
import 'features/quitrr/screens/quitrr_checkin_screen.dart';
import 'features/quitrr/screens/quitrr_peer_screen.dart';
import 'features/quitrr/screens/quitrr_crisis_screen.dart';
import 'features/health_wallet/screens/wallet_screen.dart';
import 'shared/widgets/main_shell.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
    GoRoute(path: '/welcome', builder: (context, state) => const WelcomeScreen()),
    GoRoute(
      path: '/verify-phone',
      builder: (context, state) => PhoneVerifyScreen(phoneNumber: state.extra as String?),
    ),
    GoRoute(
      path: '/token-reveal',
      builder: (context, state) => TokenRevealScreen(phoneNumber: state.extra as String?),
    ),
    GoRoute(path: '/wallet', builder: (context, state) => const WalletScreen()),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) => MainShell(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(routes: [
          GoRoute(path: '/dashboard', builder: (context, state) => const DashboardScreen()),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: '/fund',
            builder: (context, state) => const FundHomeScreen(),
            routes: [
              GoRoute(path: 'calculator', builder: (context, state) => const FundCalculatorScreen()),
              GoRoute(path: 'wallets', builder: (context, state) => const FundWalletsScreen()),
            ],
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: '/sti',
            builder: (context, state) => const StiHomeScreen(),
            routes: [
              GoRoute(path: 'reminders', builder: (context, state) => const StiRemindersScreen()),
              GoRoute(path: 'log', builder: (context, state) => const StiLogScreen()),
            ],
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: '/mind',
            builder: (context, state) => const MhHomeScreen(),
            routes: [
              GoRoute(path: 'book', builder: (context, state) => const MhBookScreen()),
              GoRoute(
                path: 'confirm',
                builder: (context, state) => MhConfirmScreen(slot: state.extra as CounsellorSlot?),
              ),
              GoRoute(path: 'mood', builder: (context, state) => const MhMoodScreen()),
            ],
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: '/quitrr',
            builder: (context, state) => const QuitrrHomeScreen(),
            routes: [
              GoRoute(path: 'checkin', builder: (context, state) => const QuitrrCheckinScreen()),
              GoRoute(path: 'peer', builder: (context, state) => const QuitrrPeerScreen()),
              GoRoute(path: 'crisis', builder: (context, state) => const QuitrrCrisisScreen()),
            ],
          ),
        ]),
      ],
    ),
  ],
);

class VitaCardApp extends StatelessWidget {
  const VitaCardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'VitaCard',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: appRouter,
    );
  }
}
