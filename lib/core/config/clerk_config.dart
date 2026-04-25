const clerkPublishableKey = String.fromEnvironment(
  'CLERK_PUBLISHABLE_KEY',
  defaultValue: 'pk_test_c2Vuc2libGUtc2xvdGgtNzEuY2xlcmsuYWNjb3VudHMuZGV2JA',
);

const clerkGoogleWebClientId = String.fromEnvironment(
  'CLERK_GOOGLE_WEB_CLIENT_ID',
  defaultValue:
      '754588546843-b7ood52rv8oi747ksrd08dchflu94a1m.apps.googleusercontent.com',
);

final isClerkConfigured =
    clerkPublishableKey != '' &&
    clerkPublishableKey != 'pk_test_replace_me' &&
    (clerkPublishableKey.startsWith('pk_test_') ||
        clerkPublishableKey.startsWith('pk_live_'));

final isClerkGoogleOauthConfigured =
    clerkGoogleWebClientId.isNotEmpty &&
    clerkGoogleWebClientId.endsWith('.apps.googleusercontent.com');
