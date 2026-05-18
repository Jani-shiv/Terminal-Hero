class UserProfile {
  const UserProfile({
    required this.id,
    required this.username,
    required this.xp,
    required this.level,
    required this.streak,
    required this.completedMissions,
    required this.rank,
    required this.badges,
    required this.avatar,
    required this.coins,
    required this.streakFreezes,
  });

  static const guest = UserProfile(
    id: 'guest',
    username: 'guest_hero',
    xp: 120,
    level: 1,
    streak: 3,
    completedMissions: [],
    rank: 'Beginner Penguin',
    badges: ['First Login'],
    avatar: '>',
    coins: 40,
    streakFreezes: 1,
  );

  final String id;
  final String username;
  final int xp;
  final int level;
  final int streak;
  final List<String> completedMissions;
  final String rank;
  final List<String> badges;
  final String avatar;
  final int coins;
  final int streakFreezes;

  int get xpForNextLevel => (level + 1) * 250;
  double get levelProgress => (xp / xpForNextLevel).clamp(0, 1).toDouble();

  UserProfile copyWith({
    String? id,
    String? username,
    int? xp,
    int? level,
    int? streak,
    List<String>? completedMissions,
    String? rank,
    List<String>? badges,
    String? avatar,
    int? coins,
    int? streakFreezes,
  }) {
    return UserProfile(
      id: id ?? this.id,
      username: username ?? this.username,
      xp: xp ?? this.xp,
      level: level ?? this.level,
      streak: streak ?? this.streak,
      completedMissions: completedMissions ?? this.completedMissions,
      rank: rank ?? this.rank,
      badges: badges ?? this.badges,
      avatar: avatar ?? this.avatar,
      coins: coins ?? this.coins,
      streakFreezes: streakFreezes ?? this.streakFreezes,
    );
  }

  Map<String, dynamic> toFirestore() => {
        'username': username,
        'xp': xp,
        'level': level,
        'streak': streak,
        'completedMissions': completedMissions,
        'rank': rank,
        'badges': badges,
        'avatar': avatar,
        'coins': coins,
        'streakFreezes': streakFreezes,
      };
}
