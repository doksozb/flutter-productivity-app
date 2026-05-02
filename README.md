<img width="900" height="900" alt="tracky" src="https://github.com/user-attachments/assets/46517274-4dc8-4faf-833f-e1ac632274b2" />


# Productivity Pro

A production-quality Flutter task management app built as a professional portfolio project.

## Tech Stack

- **Flutter** (latest stable) with Material 3
- **Firebase Auth** — email/password authentication with persistent sessions
- **Cloud Firestore** — real-time task sync (`users/{userId}/tasks/{taskId}`)
- **Riverpod 2.x** — state management (StreamProvider, AsyncNotifier, FutureProvider)
- **go_router** — declarative navigation with auth-guard redirect
- **Google Fonts (Inter)** — clean typography
- **REST API** — productivity quotes from type.fit

## Architecture

Feature-based clean architecture:

```
lib/
├── core/
│   ├── router/          # GoRouter + auth redirect notifier
│   ├── theme/           # Material 3 light/dark theme
│   └── widgets/         # Shared: loading, error, empty state
└── features/
    ├── auth/            # Login, signup, Firebase Auth repository
    ├── tasks/           # Task CRUD, real-time Firestore stream
    ├── dashboard/       # Stats derived from task stream
    ├── api/             # Quotes from REST API
    └── home/            # Bottom nav shell, splash screen
```

## Firebase Setup (Required)

1. Create a project at [console.firebase.google.com](https://console.firebase.google.com)

2. Enable **Email/Password** in Authentication → Sign-in method

3. Create a **Cloud Firestore** database (start in test mode for development)

4. Install the FlutterFire CLI and configure:

```bash
dart pub global activate flutterfire_cli
flutterfire configure --project=YOUR_FIREBASE_PROJECT_ID
```

This overwrites `lib/firebase_options.dart` with your real credentials.

5. Add Firestore security rules:

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId}/tasks/{taskId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

## Running the App

```bash
flutter pub get
flutter run
```

## Features

| Feature | Details |
|---|---|
| Auth | Email/password login & signup, persistent session, logout |
| Dashboard | Greeting, 3-stat cards (total/completed/pending), progress bar, recent tasks |
| Tasks | Real-time list, create/edit/delete, completion toggle, filter (All/Active/Done), swipe-to-delete |
| Inspiration | Productivity quotes from REST API with pull-to-refresh and offline fallback |
| UI | Material 3, dark mode support, empty states, loading indicators |
