# Terminal Hero Product Strategy

## North Star

Make Linux practice feel like a fast, rewarding game loop: open app, complete one terminal mission, gain XP, protect streak, unlock badge, share progress.

## Core Loop

1. User sees a daily mission and streak risk.
2. User enters a Linux command in the simulated terminal.
3. The app validates command syntax and mission intent.
4. Correct command triggers XP, confetti, badge progress, and unlocks.
5. The user is nudged to share a social card or continue a short mission chain.

## Retention Mechanics

- Daily challenge resets every 24 hours.
- Streak freeze protects missed days.
- Leaderboards give weekly urgency.
- Badges mark identity: permission master, SSH ninja, Docker beginner.
- Recommended lessons adapt to goals selected during onboarding.

## Monetization

- Free users get banner ads and rewarded ads for bonus coins or streak freezes.
- Premium removes ads and unlocks advanced missions, unlimited AI tutor, exclusive badges, and career tracks.

## Safety

The app must never execute user commands in a real shell. All terminal behavior goes through the simulated shell engine.
