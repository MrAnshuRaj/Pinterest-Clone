const clerkPublishableKey = String.fromEnvironment(
  'CLERK_PUBLISHABLE_KEY',
  defaultValue: 'pk_test_c2Vuc2libGUtc2xvdGgtNzEuY2xlcmsuYWNjb3VudHMuZGV2JA',
);

final isClerkConfigured =
    clerkPublishableKey != '' &&
    clerkPublishableKey != 'pk_test_replace_me' &&
    (clerkPublishableKey.startsWith('pk_test_') ||
        clerkPublishableKey.startsWith('pk_live_'));
