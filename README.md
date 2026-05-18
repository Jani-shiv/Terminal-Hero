# Terminal Hero

Terminal Hero is a dark-mode-first Flutter app that turns Linux learning into a gamified mobile experience: terminal missions, XP, levels, streaks, badges, leaderboards, daily challenges, social sharing, premium unlocks, and a fake shell sandbox.

## What Is Included

- Flutter mobile app scaffold with Riverpod state management.
- Firebase-ready Auth and Firestore repository layer.
- Email, Google, and guest authentication surfaces.
- Home dashboard with streaks, XP progress, daily challenge, leaderboard preview, achievements, and recommended lessons.
- Mission system with story objectives, command explanations, hints, XP rewards, and badge unlocks.
- Secure simulated Linux shell engine. It never executes a real system shell.
- Supported training commands: `ls`, `cd`, `pwd`, `mkdir`, `touch`, `rm`, `cp`, `mv`, `cat`, `nano`, `chmod`, `grep`, `ps`, `kill`, `ping`, `curl`, `ssh`, and `git status`.
- Leaderboard, profile, badge, social sharing, premium, offline cache, AdMob, and admin dashboard scaffolds.

## Project Structure

```text
lib/
  app/                  App root and global providers
  core/theme/           Cyberpunk terminal theme
  data/                 Sample content and Firebase repositories
  domain/models/        User and mission models
  domain/services/      Progression and simulated shell engine
  presentation/screens/ Auth, onboarding, dashboard, missions, profile, admin
  presentation/widgets/ Reusable neon cards and terminal UI
  services/             AdMob and local caching services
```

## Local Setup

1. Install Flutter stable and Android Studio.
2. From this directory, run:

```bash
flutter pub get
flutter run
```

Flutter is not installed in the current machine environment, so I could not run `flutter analyze` or launch the app here.

## Firebase Setup

1. Create a Firebase project named `terminal-hero`.
2. Enable Authentication providers:
   - Email/password
   - Google
   - Anonymous for guest mode
3. Create a Firestore database.
4. Install FlutterFire CLI:

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

5. Replace `lib/firebase_options.dart` with the generated file.
6. Suggested Firestore collections:

```text
users/{userId}
  username, xp, level, streak, completedMissions, rank, badges, avatar, coins, streakFreezes

missions/{missionId}
  title, category, story, explanation, expectedCommands, hints, xpReward, badgeReward, difficulty

dailyChallenges/{dateKey}
  missionId, rewardXp, rewardCoins, resetAt

leaderboards/global/users/{userId}
  username, xp, level, rank, countryCode, badge
```

## AdMob Setup

The code uses Google test ad unit IDs in `lib/services/ad_service.dart`.

Before release:

1. Create an AdMob app.
2. Replace test banner and rewarded IDs.
3. Add Android/iOS AdMob app IDs to the native platform manifests.
4. Keep rewarded ads tied to bonus XP, streak freezes, or coins.

## Play Store Deployment Guide

1. Update app name, package ID, launcher icon, and splash screen.
2. Configure Firebase release SHA-1/SHA-256 fingerprints.
3. Replace all placeholder Firebase and AdMob values.
4. Test on low-end Android devices.
5. Build an Android App Bundle:

```bash
flutter build appbundle --release
```

6. Upload to Play Console with:
   - Title: `Terminal Hero — Learn Linux Gamified`
   - Subtitle: `Master Linux Like a Hacker`
   - Screenshots showing dashboard, terminal mission, XP unlock, leaderboard, and achievement share card.

## Product Roadmap

- AI tutor using OpenAI or Gemini.
- Generated social achievement cards for Instagram, YouTube Shorts, and X.
- Kubernetes, Docker, cloud, and certification mission tracks.
- Multiplayer Linux battles and live competitions.
- Admin CRUD forms backed by Firestore.
- Push notifications for streak rescue and mission unlocks.
