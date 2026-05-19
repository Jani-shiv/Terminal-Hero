import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../core/theme/app_theme.dart';
import '../../data/sample_content.dart';
import '../../domain/models/mission.dart';
import '../widgets/neon_card.dart';
import 'mission_play_screen.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionProvider);
    final profile = session.profile;
    final daily = ref.watch(dailyChallengeProvider);
    final missions = ref.watch(missionsProvider);

    final firstMission = missions.isNotEmpty
      ? missions.first
      : (SampleContent.missions.isNotEmpty ? SampleContent.missions.first : Mission(
        id: 'default-mission',
        title: 'Welcome mission',
        category: MissionCategory.basicLinux,
        story: 'Welcome to Terminal Hero',
        explanation: 'This is a safe default mission.',
        expectedCommands: ['ls'],
        hints: ['Try `ls` to list files.'],
        xpReward: 10,
        badgeReward: 'Welcome Badge',
        difficulty: 1,
        ));

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppTheme.neon,
                  child: Text(profile.avatar, style: const TextStyle(color: AppTheme.ink, fontWeight: FontWeight.w900)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(profile.username, style: const TextStyle(fontWeight: FontWeight.w900)),
                      Text(profile.rank, style: const TextStyle(color: AppTheme.cyan, fontSize: 12)),
                    ],
                  ),
                ),
                _Metric(icon: Icons.local_fire_department, value: '${profile.streak}d'),
              ],
            ),
            const SizedBox(height: 18),
            NeonCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('Level ${profile.level}', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)),
                      const Spacer(),
                      Text('${profile.xp}/${profile.xpForNextLevel} XP', style: const TextStyle(color: AppTheme.neon)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: LinearProgressIndicator(
                      value: profile.levelProgress,
                      minHeight: 12,
                      backgroundColor: Colors.white10,
                      valueColor: const AlwaysStoppedAnimation(AppTheme.neon),
                    ),
                  ),
                  const SizedBox(height: 16),
                      FilledButton.icon(
                    onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => MissionPlayScreen(mission: firstMission))),
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Continue mission'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            NeonCard(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => MissionPlayScreen(mission: daily))),
              child: Row(
                children: [
                  const Icon(Icons.bolt, color: AppTheme.amber, size: 34),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Daily challenge', style: TextStyle(fontWeight: FontWeight.w900)),
                        Text(daily.title),
                      ],
                    ),
                  ),
                  Text('+${daily.xpReward} XP', style: const TextStyle(color: AppTheme.neon)),
                ],
              ),
            ),
            const SizedBox(height: 14),
            _SectionTitle(title: 'Leaderboard preview', action: '#4 today'),
            for (final row in SampleContent.leaderboard.take(3))
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: NeonCard(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Text(row.$4),
                      const SizedBox(width: 10),
                      Expanded(child: Text(row.$1, style: const TextStyle(fontWeight: FontWeight.w800))),
                      Text('${row.$2} XP', style: const TextStyle(color: AppTheme.cyan)),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 10),
            _SectionTitle(title: 'Recommended lessons', action: session.goal),
            SizedBox(
              height: 148,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: missions.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  final mission = missions[index];
                  return SizedBox(
                    width: 236,
                    child: NeonCard(
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => MissionPlayScreen(mission: mission))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(mission.title, style: const TextStyle(fontWeight: FontWeight.w900)),
                          const SizedBox(height: 8),
                          Expanded(child: Text(mission.story, maxLines: 3, overflow: TextOverflow.ellipsis)),
                          Text('+${mission.xpReward} XP', style: const TextStyle(color: AppTheme.neon)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.icon, required this.value});

  final IconData icon;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(children: [Icon(icon, color: AppTheme.amber), Text(value)]);
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, required this.action});

  final String title;
  final String action;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, top: 4),
      child: Row(
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900)),
          const Spacer(),
          Text(action, style: const TextStyle(color: AppTheme.cyan, fontSize: 12)),
        ],
      ),
    );
  }
}
