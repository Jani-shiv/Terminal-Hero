import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../app/providers.dart';
import '../../core/theme/app_theme.dart';
import '../widgets/neon_card.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(sessionProvider).profile;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile'), backgroundColor: Colors.transparent),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          NeonCard(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 42,
                  backgroundColor: AppTheme.neon,
                  child: Text(profile.avatar, style: const TextStyle(color: AppTheme.ink, fontSize: 32, fontWeight: FontWeight.w900)),
                ),
                const SizedBox(height: 12),
                Text(profile.username, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)),
                Text(profile.rank, style: const TextStyle(color: AppTheme.cyan)),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _Stat(label: 'XP', value: '${profile.xp}'),
                    _Stat(label: 'Level', value: '${profile.level}'),
                    _Stat(label: 'Streak', value: '${profile.streak}d'),
                    _Stat(label: 'Coins', value: '${profile.coins}'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          FilledButton.icon(
            onPressed: () => Share.share('I reached Level ${profile.level} in Terminal Hero. Learn Linux with Terminal Hero.'),
            icon: const Icon(Icons.ios_share),
            label: const Text('Share XP flex'),
          ),
          const SizedBox(height: 18),
          Text('Badges', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              for (final badge in profile.badges)
                Chip(
                  avatar: const Icon(Icons.workspace_premium, color: AppTheme.amber, size: 18),
                  label: Text(badge),
                  backgroundColor: AppTheme.panelAlt,
                  side: BorderSide(color: AppTheme.neon.withOpacity(0.16)),
                ),
              const Chip(label: Text('7 Day Streak')),
              const Chip(label: Text('SSH Ninja')),
              const Chip(label: Text('Docker Beginner')),
            ],
          ),
          const SizedBox(height: 18),
          NeonCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Premium', style: TextStyle(fontWeight: FontWeight.w900)),
                const SizedBox(height: 8),
                const Text('No ads, unlimited AI tutor, advanced missions, exclusive badges.'),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.diamond_outlined),
                  label: const Text('Unlock premium'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(color: AppTheme.neon, fontWeight: FontWeight.w900)),
        Text(label, style: const TextStyle(fontSize: 11)),
      ],
    );
  }
}
