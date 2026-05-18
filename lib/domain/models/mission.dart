enum MissionCategory {
  basicLinux,
  fileManagement,
  permissions,
  networking,
  processes,
  packageManagement,
  bashScripting,
  ssh,
  docker,
  git,
}

class Mission {
  const Mission({
    required this.id,
    required this.title,
    required this.category,
    required this.story,
    required this.explanation,
    required this.expectedCommands,
    required this.hints,
    required this.xpReward,
    required this.badgeReward,
    required this.difficulty,
  });

  final String id;
  final String title;
  final MissionCategory category;
  final String story;
  final String explanation;
  final List<String> expectedCommands;
  final List<String> hints;
  final int xpReward;
  final String badgeReward;
  final int difficulty;

  bool validates(String input) {
    final normalized = input.trim().replaceAll(RegExp(r'\s+'), ' ');
    return expectedCommands.contains(normalized);
  }
}
