# pinterest_clone

A pinterest clone

## Clerk setup

This app uses `clerk_flutter` for email/password auth, session restore, Google sign-in, and logout.

1. Create an app in the Clerk dashboard.
2. Enable Email/password authentication.
3. Enable Google OAuth if you want the Google button to complete sign-in.
4. Run the app with your publishable key:

```bash
flutter run --dart-define=CLERK_PUBLISHABLE_KEY=your_key_here
```

Google OAuth may require redirect/deep-link setup in your Clerk dashboard and mobile app settings, depending on how you configure the provider.

## Firebase / Firestore

This app keeps Clerk for authentication and uses Firestore for realtime user-specific data.

- Clerk is the source of truth for the signed-in user and session.
- Firestore stores profile, settings, boards, saved Pins, created Pins, collages, and inbox updates under `users/{clerkUserId}`.
- The current assignment demo uses the Clerk user id directly in Firestore document paths.
- Firebase is initialized in `main.dart` with `Firebase.initializeApp(...)` and `firebase_options.dart`.

### Firestore rules note

Current demo setup:

- Clerk is handling auth in the Flutter app.
- Firestore is not yet receiving Firebase Auth tokens derived from Clerk.
- Because of that, Firestore cannot securely enforce `request.auth.uid == clerkUserId` unless you add a Clerk-to-Firebase integration.

Option A: temporary demo/test rules only

- Use relaxed or test-mode Firestore rules during development.
- This is acceptable for an assignment demo.
- This is not safe for production.

Example temporary test rule:

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

Option B: production-safe setup

- Configure Clerk Firebase integration or a custom token flow so Firebase Auth signs the user in too.
- Make the Firebase Auth uid match the Clerk user id.
- Then restrict each user to their own subtree in Firestore rules.

Example production-style rule after Clerk/Firebase token integration:

```txt
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId}/{document=**} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }

    match /pins/{pinId} {
      allow read: if true;
      allow write: if request.auth != null;
    }
  }
}
```

Clerk does support Firebase-compatible auth integration, but that is intentionally not implemented here unless explicitly requested.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
