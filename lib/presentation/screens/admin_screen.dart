import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../widgets/neon_card.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Admin'), backgroundColor: Colors.transparent),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: const [
          NeonCard(
            child: Text(
              'Admin dashboard scaffold\nFirestore collections: missions, challenges, users, notifications',
              style: TextStyle(color: AppTheme.neon, height: 1.6),
            ),
          ),
          SizedBox(height: 14),
          _AdminAction(
              icon: Icons.add_task,
              title: 'Add mission',
              subtitle: 'Create story, command validation, XP reward'),
          _AdminAction(
              icon: Icons.bolt,
              title: 'Manage challenges',
              subtitle: 'Schedule daily tasks and streak rewards'),
          _AdminAction(
              icon: Icons.notifications_active,
              title: 'Send notification',
              subtitle: 'Streak rescue, mission unlocks, events'),
          _AdminAction(
              icon: Icons.analytics,
              title: 'Monitor users',
              subtitle: 'XP growth, retention, completion funnels'),
        ],
      ),
    );
  }
}

class _AdminAction extends StatelessWidget {
  const _AdminAction(
      {required this.icon, required this.title, required this.subtitle});

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: NeonCard(
        child: Row(
          children: [
            Icon(icon, color: AppTheme.neon),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(fontWeight: FontWeight.w900)),
                  Text(subtitle),
                ],
              ),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}
