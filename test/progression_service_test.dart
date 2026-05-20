import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:terminal_hero/app/providers.dart';
import 'package:terminal_hero/data/sample_content.dart';
import 'package:terminal_hero/domain/services/progression_service.dart';

void main() {
  test('awards XP, coins, rank, and badge from a mission reward', () {
    final mission = SampleContent.missions.first;
    final profile = ProgressionService.awardXp(
      const SessionState().profile,
      mission.xpReward,
      mission.badgeReward,
    );

    expect(profile.xp, 200);
    expect(profile.coins, 48);
    expect(profile.badges, contains(mission.badgeReward));
    expect(profile.rank, 'Beginner Penguin');
  });

  test('does not award the same mission twice in one session', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final mission = SampleContent.missions.first;
    final controller = container.read(sessionProvider.notifier);

    controller.completeMission(mission);
    final afterFirstCompletion = container.read(sessionProvider).profile;

    controller.completeMission(mission);

    final afterSecondCompletion = container.read(sessionProvider).profile;
    expect(afterSecondCompletion.xp, afterFirstCompletion.xp);
    expect(afterSecondCompletion.completedMissions, [mission.id]);
  });
}
