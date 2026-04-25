import 'package:clerk_flutter/clerk_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/router/app_router.dart';
import 'core/config/clerk_config.dart';

void main() {
  if (!isClerkConfigured) {
    runApp(const ProviderScope(child: PinterestCloneApp()));
    return;
  }

  runApp(
    ClerkAuth(
      config: ClerkAuthConfig(
        publishableKey: clerkPublishableKey,
        loading: const _AppBootLoader(),
      ),
      child: const ProviderScope(child: PinterestCloneApp()),
    ),
  );
}

class PinterestCloneApp extends ConsumerWidget {
  const PinterestCloneApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = isClerkConfigured ? ClerkAuth.of(context) : null;
    final router = ref.watch(appRouterProvider(authState));
    final baseTheme = ThemeData.dark(useMaterial3: true);

    final app = MaterialApp.router(
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

    return app;
  }
}

class _AppBootLoader extends StatelessWidget {
  const _AppBootLoader();

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFFE60023)),
        ),
      ),
    );
  }
}
