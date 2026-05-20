import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../data/sample_content.dart';
import '../widgets/neon_card.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Leaderboards'),
          backgroundColor: Colors.transparent),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(
                  value: 'global',
                  label: Text('Global'),
                  icon: Icon(Icons.public)),
              ButtonSegment(
                  value: 'weekly',
                  label: Text('Weekly'),
                  icon: Icon(Icons.bolt)),
              ButtonSegment(
                  value: 'friends',
                  label: Text('Friends'),
                  icon: Icon(Icons.group)),
            ],
            selected: const {'global'},
            onSelectionChanged: (_) {},
          ),
          const SizedBox(height: 18),
          for (var i = 0; i < SampleContent.leaderboard.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: NeonCard(
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: i < 3
                            ? AppTheme.amber.withValues(alpha: 0.16)
                            : Colors.white10,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text('#${i + 1}',
                          style: const TextStyle(fontWeight: FontWeight.w900)),
                    ),
                    const SizedBox(width: 12),
                    Text(SampleContent.leaderboard[i].$4),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(SampleContent.leaderboard[i].$1,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w900)),
                          Text(SampleContent.leaderboard[i].$3,
                              style: const TextStyle(
                                  color: AppTheme.cyan, fontSize: 12)),
                        ],
                      ),
                    ),
                    Text('${SampleContent.leaderboard[i].$2} XP',
                        style: const TextStyle(color: AppTheme.neon)),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
