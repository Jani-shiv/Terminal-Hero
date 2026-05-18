import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme/app_theme.dart';
import '../presentation/screens/auth_screen.dart';
import '../presentation/screens/onboarding_screen.dart';
import '../presentation/screens/shell_screen.dart';
import 'providers.dart';

class TerminalHeroApp extends ConsumerWidget {
  const TerminalHeroApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionProvider);

    return MaterialApp(
      title: 'Terminal Hero',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark(),
      home: AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        child: switch (session.stage) {
          AppStage.auth => const AuthScreen(),
          AppStage.onboarding => const OnboardingScreen(),
          AppStage.app => const ShellScreen(),
        },
      ),
    );
  }
}
