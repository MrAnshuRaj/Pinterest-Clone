import 'package:clerk_flutter/clerk_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/login/login_screen.dart';
import '../../features/auth/presentation/screens/auth_landing_screen.dart';
import '../../features/auth/presentation/signup/signup_flow_screen.dart';
import '../../features/create/presentation/collage/collage_editor_screen.dart';
import '../../features/create/presentation/collage/collage_photo_picker_screen.dart';
import '../../features/create/presentation/collage/collage_publish_screen.dart';
import '../../features/create/presentation/create_pin/advanced_settings_screen.dart';
import '../../features/create/presentation/create_pin/create_pin_screen.dart';
import '../../features/create/presentation/create_pin/tag_topics_screen.dart';
import '../../features/home/data/models/pin_model.dart';
import '../../features/main/presentation/main_shell.dart';
import '../../features/pin_detail/presentation/pin_detail_screen.dart';
import '../../features/search/presentation/filter_screen.dart';
import '../../features/search/presentation/search_results_screen.dart';
import '../../features/search/presentation/search_typing_screen.dart';

final appRouterProvider = Provider.family<GoRouter, ClerkAuthState?>((
  ref,
  authState,
) {
  final router = GoRouter(
    refreshListenable: authState,
    redirect: (context, state) {
      if (authState == null) {
        return null;
      }

      final path = state.uri.path;
      final isAuthRoute =
          path == '/' ||
          path == '/auth' ||
          path == '/login' ||
          path == '/signup';

      final isSignedIn = authState.isSignedIn;

      if (!isSignedIn && !isAuthRoute) {
        return '/';
      }

      if (isSignedIn && isAuthRoute) {
        return '/main';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const AuthLandingScreen(),
      ),
      GoRoute(
        path: '/auth',
        builder: (context, state) => const AuthLandingScreen(),
      ),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/signup',
        builder: (context, state) {
          return SignupFlowScreen(initialEmail: state.extra as String?);
        },
      ),
      GoRoute(path: '/main', builder: (context, state) => const MainShell()),
      GoRoute(path: '/home', builder: (context, state) => const MainShell()),
      GoRoute(
        path: '/inbox',
        builder: (context, state) => const MainShell(initialIndex: 3),
      ),
      GoRoute(
        path: '/saved',
        builder: (context, state) => const MainShell(initialIndex: 4),
      ),
      GoRoute(
        path: '/search',
        builder: (context, state) => const MainShell(initialIndex: 1),
      ),
      GoRoute(
        path: '/search/type',
        builder: (context, state) {
          return SearchTypingScreen(initialQuery: state.extra as String?);
        },
      ),
      GoRoute(
        path: '/search/results/:query',
        builder: (context, state) {
          final query = state.pathParameters['query'] ?? '';
          return MainShell(
            initialIndex: 1,
            searchChild: SearchResultsScreen(query: query),
          );
        },
      ),
      GoRoute(
        path: '/search/filter',
        builder: (context, state) {
          return FilterScreen(
            initialFilter: state.extra as String? ?? 'All Pins',
          );
        },
      ),
      GoRoute(
        path: '/pin/:id',
        builder: (context, state) {
          final pin = state.extra is PinModel ? state.extra as PinModel : null;
          return PinDetailScreen(
            pinId: state.pathParameters['id'] ?? '',
            initialPin: pin,
          );
        },
      ),
      GoRoute(
        path: '/create/pin',
        builder: (context, state) => const CreatePinScreen(),
      ),
      GoRoute(
        path: '/create/pin/topics',
        builder: (context, state) => TagTopicsScreen(
          initialSelected: state.extra is List<String>
              ? state.extra as List<String>
              : const [],
        ),
      ),
      GoRoute(
        path: '/create/pin/advanced',
        builder: (context, state) => const AdvancedSettingsScreen(),
      ),
      GoRoute(
        path: '/create/collage',
        builder: (context, state) => const CollageEditorScreen(),
      ),
      GoRoute(
        path: '/create/collage/photos',
        builder: (context, state) => const CollagePhotoPickerScreen(),
      ),
      GoRoute(
        path: '/create/collage/publish',
        builder: (context, state) {
          final collage = state.extra is CreatedCollage
              ? state.extra as CreatedCollage
              : CreatedCollage(
                  id: 'empty',
                  title: '',
                  description: '',
                  imageUrls: const [
                    'https://images.unsplash.com/photo-1500534314209-a25ddb2bd429?auto=format&fit=crop&w=900&q=85',
                  ],
                  createdAt: DateTime.now(),
                );
          return CollagePublishScreen(collage: collage);
        },
      ),
    ],
  );

  ref.onDispose(router.dispose);
  return router;
});
