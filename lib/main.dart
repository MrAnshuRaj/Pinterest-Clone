import 'dart:async';
import 'dart:io';

import 'package:app_links/app_links.dart';
import 'package:clerk_flutter/clerk_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/router/app_router.dart';
import 'core/config/auth_config.dart';
import 'core/config/clerk_config.dart';
import 'features/auth/application/auth_providers.dart';
import 'features/profile/application/profile_providers.dart';
import 'firebase_options.dart';

final _appLinks = AppLinks();
final _clerkDeepLinkController = StreamController<Uri?>();

Future<Uri?> _handleClerkDeepLink(Uri uri) async {
  if (!isClerkHandledDeepLink(uri)) {
    return null;
  }

  debugPrint('[auth][deep-link] received $uri');
  return uri;
}

Future<void> _setUpClerkDeepLinks() async {
  final initialUri = await _appLinks.getInitialAppLink();
  if (initialUri != null) {
    final handledUri = await _handleClerkDeepLink(initialUri);
    if (handledUri != null) {
      debugPrint('[auth][deep-link] initial $handledUri');
      _clerkDeepLinkController.add(handledUri);
    }
  }

  _appLinks.uriLinkStream.asyncMap(_handleClerkDeepLink).listen((uri) {
    if (uri != null) {
      _clerkDeepLinkController.add(uri);
    }
  });
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isAndroid || Platform.isIOS) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  if (!isClerkConfigured) {
    runApp(const ProviderScope(child: PinterestCloneApp()));
    return;
  }

  await _setUpClerkDeepLinks();

  runApp(
    ClerkAuth(
      config: ClerkAuthConfig(
        publishableKey: clerkPublishableKey,
        redirectionGenerator: clerkRedirectUriFor,
        deepLinkStream: _clerkDeepLinkController.stream,
        loading: const _AppBootLoader(),
      ),
      child: const ProviderScope(child: PinterestCloneApp()),
    ),
  );
}

class PinterestCloneApp extends StatelessWidget {
  const PinterestCloneApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = isClerkConfigured ? ClerkAuth.of(context) : null;
    final isAuthBooting =
        isClerkConfigured &&
        authState != null &&
        (authState.isNotAvailable || authState.client.isEmpty);
    if (isAuthBooting) {
      return const _AppBootLoader();
    }

    return ProviderScope(
      overrides: [clerkAuthStateProvider.overrideWithValue(authState)],
      child: const _PinterestCloneAppView(),
    );
  }
}

class _PinterestCloneAppView extends ConsumerWidget {
  const _PinterestCloneAppView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(clerkAuthStateProvider);
    final router = ref.watch(appRouterProvider(authState));
    ref.watch(profileBootstrapProvider);
    final baseTheme = ThemeData.dark(useMaterial3: true);

    return MaterialApp.router(
      title: 'Pinterest Clone',
      debugShowCheckedModeBanner: false,
      theme: baseTheme.copyWith(
        scaffoldBackgroundColor: Colors.black,
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFE60023),
          surface: Colors.black,
        ),
        textTheme: baseTheme.textTheme.apply(
          bodyColor: Colors.white,
          displayColor: Colors.white,
        ),
        splashFactory: InkRipple.splashFactory,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.transparent,
          hintStyle: const TextStyle(
            color: Color(0xFF8C8C8C),
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: Color(0xFF454545)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: Colors.white),
          ),
        ),
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: Color(0xFF161616),
        ),
      ),
      builder: (context, child) {
        if (child == null) {
          return const SizedBox.shrink();
        }

        return isClerkConfigured ? ClerkErrorListener(child: child) : child;
      },
      routerConfig: router,
    );
  }
}

class _AppBootLoader extends StatelessWidget {
  const _AppBootLoader();

  static const _pinterestRed = Color(0xFFE60023);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF111111), Color(0xFF000000)],
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 320),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: const Color(0xFF161616),
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: Colors.white10),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x40000000),
                        blurRadius: 24,
                        offset: Offset(0, 14),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(28, 32, 28, 28),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 88,
                          height: 88,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(18),
                          child: Image.asset('assets/app_icon/pinterest.png'),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'Pinterest',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.6,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Loading your inspiration',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFFB8B8B8),
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 28),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(999),
                          child: const LinearProgressIndicator(
                            minHeight: 8,
                            backgroundColor: Color(0xFF2A2A2A),
                            color: _pinterestRed,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
