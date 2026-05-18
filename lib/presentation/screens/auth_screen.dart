import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../core/theme/app_theme.dart';
import '../widgets/neon_card.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(22),
          children: [
            const SizedBox(height: 28),
            Text(
              'Terminal Hero',
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: AppTheme.neon,
                  ),
            ),
            const SizedBox(height: 8),
            const Text('Master Linux like a hacker. One mission at a time.'),
            const SizedBox(height: 28),
            const NeonCard(
              child: Text(
                '> booting dopamine-driven Linux training...\n> loading missions\n> sandbox ready',
                style: TextStyle(color: AppTheme.neon, height: 1.6),
              ),
            ),
            const SizedBox(height: 18),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () {
                final name = emailController.text.split('@').first;
                ref.read(sessionProvider.notifier).signIn(name.isEmpty ? 'terminal_hero' : name);
              },
              child: const Text('Start learning'),
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: () => ref.read(sessionProvider.notifier).continueAsGuest(),
              child: const Text('Continue as guest'),
            ),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: () => ref.read(sessionProvider.notifier).signIn('google_hero'),
              icon: const Icon(Icons.g_mobiledata),
              label: const Text('Continue with Google'),
            ),
          ],
        ),
      ),
    );
  }
}
