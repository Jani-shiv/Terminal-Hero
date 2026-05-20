import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/models/mission.dart';
import '../widgets/neon_card.dart';
import 'mission_play_screen.dart';

class MissionsScreen extends ConsumerWidget {
  const MissionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final missions = ref.watch(missionsProvider);

    return Scaffold(
      appBar: AppBar(
          title: const Text('Missions'), backgroundColor: Colors.transparent),
      body: ListView.separated(
        padding: const EdgeInsets.all(18),
        itemCount: missions.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final mission = missions[index];
          return NeonCard(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => MissionPlayScreen(mission: mission))),
            child: Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: AppTheme.neon.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(_iconFor(mission.category), color: AppTheme.neon),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(mission.title,
                          style: const TextStyle(fontWeight: FontWeight.w900)),
                      const SizedBox(height: 4),
                      Text(mission.story,
                          maxLines: 2, overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
                Text('+${mission.xpReward}',
                    style: const TextStyle(color: AppTheme.cyan)),
              ],
            ),
          );
        },
      ),
    );
  }

  IconData _iconFor(MissionCategory category) {
    return switch (category) {
      MissionCategory.basicLinux => Icons.terminal,
      MissionCategory.fileManagement => Icons.folder,
      MissionCategory.permissions => Icons.lock,
      MissionCategory.networking => Icons.public,
      MissionCategory.processes => Icons.memory,
      MissionCategory.packageManagement => Icons.inventory_2,
      MissionCategory.bashScripting => Icons.code,
      MissionCategory.ssh => Icons.key,
      MissionCategory.docker => Icons.developer_board,
      MissionCategory.git => Icons.account_tree,
    };
  }
}
