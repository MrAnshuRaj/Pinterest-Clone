# pinterest_clone

A Flutter Pinterest-inspired app with authentication, feed browsing, saved content, profile screens, creation flows, and Firestore-backed user data.

## Overview

This project is structured as a feature-first Flutter app.

- `lib/main.dart`: app bootstrap, Firebase initialization, Clerk initialization, theme setup
- `lib/app/router`: `go_router` routes and navigation guards
- `lib/core`: shared config and Firebase helpers
- `lib/features/auth`: email OTP auth, Google OAuth, onboarding, session/profile bootstrap
- `lib/features/home`: home feed UI and feed data
- `lib/features/search`: search flow and search results
- `lib/features/saved`: saved boards and saved content
- `lib/features/create`: create pin, board, and collage flows
- `lib/features/profile`: account/profile UI, profile repository, settings
- `lib/features/inbox`: inbox/update seeding and presentation
- `lib/shared`: reusable widgets

## Tech Stack

- Flutter
- Riverpod
- GoRouter
- Clerk (`clerk_flutter`, `clerk_auth`)
- Firebase Core
- Cloud Firestore

## Authentication

The app currently supports:

- Email sign-in with Clerk email verification code / OTP
- Email sign-up with Clerk email verification code / OTP
- Google OAuth sign-in through Clerk

The email flow is:

- Login: `email -> send code -> verify code -> signed in`
- Signup: `email -> onboarding -> send code -> verify code -> signed in`

Password-based Clerk email auth is not used in the current flow.

## Project Structure

The codebase mainly follows this pattern inside each feature:

- `application`: providers, controllers, state orchestration
- `data`: repositories, models, services
- `presentation`: screens, widgets, UI state

This keeps UI, business flow, and persistence concerns separated while still being easy to navigate.

## Requirements

Before running the app, make sure you have:

- Flutter SDK installed
- A working Android Studio / VS Code Flutter setup
- At least one emulator or physical device
- A Clerk application
- A Firebase project if you want Firestore-backed data to work

## Installation

1. Clone the repository.

```bash
git clone <your-repo-url>
cd pinterest_clone
```

2. Install Flutter packages.

```bash
flutter pub get
```

3. Verify your Flutter environment.

```bash
flutter doctor
```

## Clerk Setup

Create a Clerk app and configure it for the flows used by this project.

Enable these settings in the Clerk dashboard:

- Sign-in with email
- Email verification code
- Google OAuth if you want the Google button enabled

Disable or ignore these for the current app flow:

- Email verification link
- Password-based email sign-in

Run the app with your Clerk publishable key:

```bash
flutter run --dart-define=CLERK_PUBLISHABLE_KEY=your_key_here
```

The app reads the key from `CLERK_PUBLISHABLE_KEY` in [clerk_config.dart](lib/core/config/clerk_config.dart).

## Google OAuth Callback

Google sign-in uses Clerk's redirect-based OAuth flow with the custom callback:

- Scheme: `yourapp`
- Host: `auth-callback`

These values are defined in [auth_config.dart](lib/core/config/auth_config.dart).

For Android, keep an intent filter like this in `android/app/src/main/AndroidManifest.xml`:

```xml
<intent-filter>
    <action android:name="android.intent.action.VIEW"/>
    <category android:name="android.intent.category.DEFAULT"/>
    <category android:name="android.intent.category.BROWSABLE"/>
    <data android:scheme="yourapp" android:host="auth-callback"/>
</intent-filter>
```

Also add the same callback URL to your Clerk OAuth redirect settings:

```txt
yourapp://auth-callback
```

## Firebase / Firestore Setup

Firebase is initialized in `main.dart` for Android and iOS using `firebase_options.dart`.

If you are connecting the app to your own Firebase project:

1. Create a Firebase project.
2. Register your Android/iOS app.
3. Generate Firebase config for Flutter.
4. Replace or regenerate `lib/firebase_options.dart`.

Common way to generate the config:

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

## Firestore Data Notes

Clerk handles app authentication, while Firestore stores user app data such as:

- profile
- settings
- inbox updates
- saved data
- created content

The app stores documents under the Clerk user id path, for example:

```txt
users/{clerkUserId}
```

For demo builds, relaxed Firestore rules may be used during development. For production, you should connect Clerk identity to Firebase Auth or use a trusted backend so Firestore rules can safely enforce per-user access.

Example development-only rule:

```txt
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if true;
    }
  }
}
```

## Running the App

Basic run:

```bash
flutter run --dart-define=CLERK_PUBLISHABLE_KEY=your_key_here
```

Run on a specific device:

```bash
flutter devices
flutter run -d <device_id> --dart-define=CLERK_PUBLISHABLE_KEY=your_key_here
```

## Useful Commands

```bash
flutter pub get
flutter analyze
flutter test
flutter run
```

## Notes

- If Clerk is not configured, the app can still boot, but auth-dependent flows will not work correctly.
- Google sign-in opens the browser and returns through the app callback deep link.
- Email auth is OTP-based only in the current implementation.
