import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/sample_content.dart';
import '../domain/models/mission.dart';
import '../domain/models/user_profile.dart';
import '../domain/services/progression_service.dart';
import '../domain/services/shell_engine.dart';

enum AppStage { auth, onboarding, app }

class SessionState {
  const SessionState({
    this.stage = AppStage.auth,
    this.profile = UserProfile.guest,
    this.goal = 'Linux basics',
  });

  final AppStage stage;
  final UserProfile profile;
  final String goal;

  SessionState copyWith({
    AppStage? stage,
    UserProfile? profile,
    String? goal,
  }) {
    return SessionState(
      stage: stage ?? this.stage,
      profile: profile ?? this.profile,
      goal: goal ?? this.goal,
    );
  }
}

class SessionController extends StateNotifier<SessionState> {
  SessionController() : super(const SessionState());

  void continueAsGuest() {
    state = state.copyWith(
      stage: AppStage.onboarding,
      profile: UserProfile.guest,
    );
  }

  void signIn(String username) {
    state = state.copyWith(
      stage: AppStage.onboarding,
      profile: UserProfile.guest.copyWith(username: username),
    );
  }

  void completeOnboarding(String goal) {
    state = state.copyWith(stage: AppStage.app, goal: goal);
  }

  void completeMission(Mission mission) {
    final nextProfile = ProgressionService.awardXp(
      state.profile,
      mission.xpReward,
      mission.badgeReward,
    );
    state = state.copyWith(profile: nextProfile);
  }
}

final sessionProvider =
    StateNotifierProvider<SessionController, SessionState>((ref) {
  return SessionController();
});

final missionsProvider = Provider<List<Mission>>((ref) => SampleContent.missions);

final dailyChallengeProvider = Provider<Mission>((ref) {
  final missions = ref.watch(missionsProvider);
  if (missions.isEmpty) {
    // Fallback: if sample content is empty (unexpected), return a minimal mission
    return const Mission(
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
    );
  }

  return missions[DateTime.now().day % missions.length];
});

final shellEngineProvider = Provider<ShellEngine>((ref) => ShellEngine.seeded());
