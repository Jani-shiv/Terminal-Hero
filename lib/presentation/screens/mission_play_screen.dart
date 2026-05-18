import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/models/mission.dart';
import '../widgets/neon_card.dart';
import '../widgets/terminal_window.dart';

class MissionPlayScreen extends ConsumerStatefulWidget {
  const MissionPlayScreen({required this.mission, super.key});

  final Mission mission;

  @override
  ConsumerState<MissionPlayScreen> createState() => _MissionPlayScreenState();
}

class _MissionPlayScreenState extends ConsumerState<MissionPlayScreen> {
  final controller = TextEditingController();
  final confetti = ConfettiController(duration: const Duration(seconds: 2));
  final lines = <String>['Welcome to Terminal Hero training sandbox.'];
  int attempts = 0;
  bool completed = false;
  String draft = '';

  @override
  void dispose() {
    controller.dispose();
    confetti.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final engine = ref.watch(shellEngineProvider);

    return Scaffold(
      appBar: AppBar(title: Text(widget.mission.title), backgroundColor: Colors.transparent),
      body: Stack(
        children: [
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(18),
              children: [
                NeonCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.mission.story, style: const TextStyle(fontWeight: FontWeight.w900)),
                      const SizedBox(height: 8),
                      Text(widget.mission.explanation),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(Icons.workspace_premium, color: AppTheme.amber),
                          const SizedBox(width: 8),
                          Text('+${widget.mission.xpReward} XP'),
                          const Spacer(),
                          Text('Difficulty ${widget.mission.difficulty}', style: const TextStyle(color: AppTheme.cyan)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 420,
                  child: TerminalWindow(
                    lines: lines,
                    cwd: engine.cwd,
                    controller: controller,
                    suggestions: engine.suggestions(draft),
                    onChanged: (value) => setState(() => draft = value),
                    onSubmitted: _submit,
                  ),
                ),
                const SizedBox(height: 12),
                if (!completed && attempts > 0)
                  NeonCard(
                    child: Row(
                      children: [
                        const Icon(Icons.lightbulb_outline, color: AppTheme.amber),
                        const SizedBox(width: 10),
                        Expanded(child: Text(widget.mission.hints[(attempts - 1).clamp(0, widget.mission.hints.length - 1)])),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: confetti,
              blastDirectionality: BlastDirectionality.explosive,
              colors: const [AppTheme.neon, AppTheme.cyan, AppTheme.magenta, AppTheme.amber],
            ),
          ),
        ],
      ),
    );
  }

  void _submit(String input) {
    final engine = ref.read(shellEngineProvider);
    final result = engine.run(input);
    final missionSolved = widget.mission.validates(input);

    setState(() {
      lines.add('hero:${engine.cwd}\$ $input');
      if (result.output == '__CLEAR__') {
        lines.clear();
      } else if (result.output.isNotEmpty) {
        lines.add(result.output);
      }
      if (result.suggestion != null) lines.add('hint: did you mean ${result.suggestion}?');
      controller.clear();
      draft = '';
      attempts += missionSolved ? 0 : 1;
    });

    if (missionSolved && !completed) {
      completed = true;
      confetti.play();
      ref.read(sessionProvider.notifier).completeMission(widget.mission);
      setState(() {
        lines.add('MISSION COMPLETE: +${widget.mission.xpReward} XP, badge unlocked: ${widget.mission.badgeReward}');
      });
    }
  }
}
