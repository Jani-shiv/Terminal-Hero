import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../core/theme/app_theme.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  String selected = 'Linux basics';

  final goals = const [
    ('Linux basics', Icons.terminal),
    ('DevOps', Icons.hub),
    ('Cybersecurity', Icons.security),
    ('Cloud engineering', Icons.cloud),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Choose your path',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 8),
              const Text('Terminal Hero will tune missions, streak nudges, and challenges around your goal.'),
              const SizedBox(height: 24),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  children: [
                    for (final goal in goals)
                      InkWell(
                        onTap: () => setState(() => selected = goal.$1),
                        borderRadius: BorderRadius.circular(8),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 220),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: selected == goal.$1 ? AppTheme.neon.withOpacity(0.15) : AppTheme.panel,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: selected == goal.$1 ? AppTheme.neon : AppTheme.neon.withOpacity(0.15),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(goal.$2, color: selected == goal.$1 ? AppTheme.neon : AppTheme.cyan),
                              const Spacer(),
                              Text(goal.$1, style: const TextStyle(fontWeight: FontWeight.w800)),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              FilledButton(
                onPressed: () => ref.read(sessionProvider.notifier).completeOnboarding(selected),
                child: const Center(child: Text('Enter the terminal')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
