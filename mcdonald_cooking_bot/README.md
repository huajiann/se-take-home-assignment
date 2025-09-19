# McDonald Cooking Bot

A Flutter app that simulates a queue of food orders being processed by worker bots. Orders can be VIP or Normal and are assigned to idle bots based on priority and arrival time.

## Features

- Add VIP and Normal orders from the Pending Orders tab.
- VIP orders are prioritized ahead of Normal orders already in the queue.
- Bots pick up queued orders automatically as they become idle.
- Live status updates for bot activity and order progression.
- Completed orders are listed in a separate tab.

## Tech Stack

- Flutter Version: 3.32.8
- Dart Version: 3.8.1

## Getting Started

- Prereqs: Flutter SDK (stable), Dart, Android/iOS setup.
- Install dependencies:

```dart
  flutter pub get
```

- Run:

```dart
flutter run
```

- Platforms: Android and iOS.

## Project Structure

- lib/
  - modules/
    - orders/ (models, view models, pages, widgets)
    - bots/ (models, view models, pages)
  - utils/ (enums, constants)
- android/, ios/: platform code
- build/: generated artifacts
