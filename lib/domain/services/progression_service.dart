import '../models/user_profile.dart';

class ProgressionService {
  /// Applies XP, level, rank, coin, and badge rewards after a solved mission.
  static UserProfile awardXp(
    UserProfile profile,
    int xp,
    String badge,
  ) {
    final totalXp = profile.xp + xp;
    final level = (totalXp ~/ 250) + 1;
    final badges = {...profile.badges, badge}.toList();

    return profile.copyWith(
      xp: totalXp,
      level: level,
      rank: rankForLevel(level),
      badges: badges,
      coins: profile.coins + (xp ~/ 10),
    );
  }

  static String rankForLevel(int level) {
    if (level >= 20) return 'DevOps Master';
    if (level >= 14) return 'Linux Ninja';
    if (level >= 8) return 'Shell Warrior';
    if (level >= 3) return 'Terminal Rookie';
    return 'Beginner Penguin';
  }
}
