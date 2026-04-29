import 'package:clerk_auth/clerk_auth.dart' as clerk;
import 'package:flutter/widgets.dart';

const clerkOauthCallbackScheme = 'yourapp';
const clerkOauthCallbackHost = 'auth-callback';

Uri get clerkOauthCallbackUri =>
    Uri(scheme: clerkOauthCallbackScheme, host: clerkOauthCallbackHost);

Uri? clerkRedirectUriFor(BuildContext _, clerk.Strategy strategy) {
  if (strategy.isOauth) {
    return clerkOauthCallbackUri;
  }

  return null;
}

bool isClerkHandledDeepLink(Uri uri) {
  return uri.scheme == clerkOauthCallbackScheme &&
      uri.host == clerkOauthCallbackHost;
}
