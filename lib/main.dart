import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'features/auth/presentation/screens/auth_landing_screen.dart';
import 'features/auth/presentation/signup/signup_flow_screen.dart';
import 'features/home/presentation/screens/home_placeholder_screen.dart';

final _router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const AuthLandingScreen()),
    GoRoute(
      path: '/signup',
      builder: (context, state) {
        return SignupFlowScreen(initialEmail: state.extra as String?);
      },
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomePlaceholderScreen(),
    ),
  ],
);

void main() {
  runApp(const ProviderScope(child: PinterestCloneApp()));
}

class PinterestCloneApp extends StatelessWidget {
  const PinterestCloneApp({super.key});

  @override
  Widget build(BuildContext context) {
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
      routerConfig: _router,
    );
  }
}
