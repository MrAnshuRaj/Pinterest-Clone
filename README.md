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

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
