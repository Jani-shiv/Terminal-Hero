import '../domain/models/mission.dart';

class SampleContent {
  static const missions = <Mission>[
    Mission(
      id: 'basic-hidden-file',
      title: 'Find the Hidden File',
      category: MissionCategory.basicLinux,
      story: 'A server contains a hidden clue. Reveal every file in the room.',
      explanation:
          'Use ls to list files. Add -la to include hidden files and details.',
      expectedCommands: ['ls -la', 'ls -al'],
      hints: [
        'Hidden files start with a dot.',
        'Try combining long and all flags.'
      ],
      xpReward: 80,
      badgeReward: 'First Command',
      difficulty: 1,
    ),
    Mission(
      id: 'file-create-vault',
      title: 'Create the Vault',
      category: MissionCategory.fileManagement,
      story: 'Your team needs a secure workspace named vault.',
      explanation: 'mkdir creates directories in the current location.',
      expectedCommands: ['mkdir vault'],
      hints: [
        'The command starts with mkdir.',
        'Use the target directory name after it.'
      ],
      xpReward: 90,
      badgeReward: 'Linux Explorer',
      difficulty: 1,
    ),
    Mission(
      id: 'permissions-lock-script',
      title: 'Lock the Script',
      category: MissionCategory.permissions,
      story:
          'A deploy script is too open. Make it executable only for the owner.',
      explanation:
          'chmod 700 gives the owner read, write, execute permissions.',
      expectedCommands: ['chmod 700 deploy.sh'],
      hints: ['Permissions can be numeric.', 'Owner-only full access is 700.'],
      xpReward: 130,
      badgeReward: 'Permission Master',
      difficulty: 2,
    ),
    Mission(
      id: 'network-ping-gateway',
      title: 'Ping the Gateway',
      category: MissionCategory.networking,
      story: 'Check whether the training gateway is alive.',
      explanation: 'ping tests network reachability to a host.',
      expectedCommands: ['ping gateway.local'],
      hints: ['Use ping followed by the host.', 'The host is gateway.local.'],
      xpReward: 100,
      badgeReward: 'Packet Scout',
      difficulty: 2,
    ),
    Mission(
      id: 'process-find-daemon',
      title: 'Find the Daemon',
      category: MissionCategory.processes,
      story: 'Spot the running backup process before it eats the CPU budget.',
      explanation: 'ps lists active processes. aux is a common full listing.',
      expectedCommands: ['ps aux'],
      hints: ['The command is ps.', 'Use aux for a complete process view.'],
      xpReward: 110,
      badgeReward: 'Process Hunter',
      difficulty: 2,
    ),
    Mission(
      id: 'git-status-check',
      title: 'Check the Repo Pulse',
      category: MissionCategory.git,
      story: 'Before shipping the patch, inspect the repository status.',
      explanation: 'git status shows staged, unstaged, and untracked changes.',
      expectedCommands: ['git status'],
      hints: [
        'Use git followed by a state-checking subcommand.',
        'The command is two words.'
      ],
      xpReward: 95,
      badgeReward: 'Git Initiate',
      difficulty: 1,
    ),
  ];

  static const leaderboard = [
    ('root_rider', 8420, 'DevOps Master', 'IN'),
    ('shell_queen', 7760, 'Linux Ninja', 'US'),
    ('sudo_sam', 6910, 'Shell Warrior', 'BR'),
    ('guest_hero', 120, 'Beginner Penguin', 'IN'),
  ];
}
