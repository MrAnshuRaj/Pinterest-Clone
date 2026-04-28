import 'package:clerk_flutter/clerk_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/login/login_screen.dart';
import '../../features/auth/presentation/screens/auth_landing_screen.dart';
import '../../features/auth/presentation/signup/signup_flow_screen.dart';
import '../../features/create/presentation/collage/collage_editor_screen.dart';
import '../../features/create/presentation/collage/collage_photo_picker_screen.dart';
import '../../features/create/presentation/collage/collage_publish_screen.dart';
import '../../features/create/data/models/created_collage_model.dart';
import '../../features/create/presentation/create_board/create_board_screen.dart';
import '../../features/create/presentation/create_board/save_pins_to_board_screen.dart';
import '../../features/create/presentation/create_pin/advanced_settings_screen.dart';
import '../../features/create/presentation/create_pin/create_pin_screen.dart';
import '../../features/create/presentation/create_pin/tag_topics_screen.dart';
import '../../features/home/data/models/pin_model.dart';
import '../../features/main/presentation/main_shell.dart';
import '../../features/pin_detail/presentation/pin_detail_screen.dart';
import '../../features/profile/presentation/edit_profile_screen.dart';
import '../../features/profile/presentation/profile_collection_screen.dart';
import '../../features/profile/presentation/public_profile_screen.dart';
import '../../features/profile/presentation/settings/account_management_screen.dart';
import '../../features/profile/presentation/settings/account_settings_screen.dart';
import '../../features/profile/presentation/settings/add_account_screen.dart';
import '../../features/profile/presentation/settings/birthdate_settings_screen.dart';
import '../../features/profile/presentation/settings/change_password_screen.dart';
import '../../features/profile/presentation/settings/claim_instagram_screen.dart';
import '../../features/profile/presentation/settings/convert_business_account_screen.dart';
import '../../features/profile/presentation/settings/country_region_screen.dart';
import '../../features/profile/presentation/settings/deactivate_account_screen.dart';
import '../../features/profile/presentation/settings/delete_account_screen.dart';
import '../../features/profile/presentation/settings/gender_settings_screen.dart';
import '../../features/profile/presentation/settings/language_screen.dart';
import '../../features/profile/presentation/settings/login_options_screen.dart';
import '../../features/profile/presentation/settings/notifications_settings_screen.dart';
import '../../features/profile/presentation/settings/personal_information_screen.dart';
import '../../features/profile/presentation/settings/privacy_data_screen.dart';
import '../../features/profile/presentation/settings/profile_visibility_screen.dart';
import '../../features/profile/presentation/settings/refine_recommendations_screen.dart';
import '../../features/profile/presentation/settings/reports_violations_screen.dart';
import '../../features/profile/presentation/settings/security_logins_screen.dart';
import '../../features/profile/presentation/settings/social_permissions_screen.dart';
import '../../features/search/presentation/filter_screen.dart';
import '../../features/search/presentation/search_results_screen.dart';
import '../../features/search/presentation/search_typing_screen.dart';

final appRouterProvider = Provider.family<GoRouter, ClerkAuthState?>((
  ref,
  authState,
) {
  final router = GoRouter(
    initialLocation: authState?.isSignedIn == true ? '/main' : '/',
    refreshListenable: authState,
    redirect: (context, state) {
      if (authState == null) {
        return null;
      }

      if (authState.isNotAvailable) {
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
        path: '/create/board',
        builder: (context, state) => const CreateBoardScreen(),
      ),
      GoRoute(
        path: '/create/board/:boardId/save-pins',
        builder: (context, state) {
          return SavePinsToBoardScreen(
            boardId: state.pathParameters['boardId'] ?? '',
          );
        },
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
          final collage = state.extra is CreatedCollageModel
              ? state.extra as CreatedCollageModel
              : CreatedCollageModel(
                  id: 'empty',
                  title: '',
                  description: '',
                  imageUrls: const [
                    'https://images.unsplash.com/photo-1500534314209-a25ddb2bd429?auto=format&fit=crop&w=900&q=85',
                  ],
                  previewImageUrl:
                      'https://images.unsplash.com/photo-1500534314209-a25ddb2bd429?auto=format&fit=crop&w=900&q=85',
                  isDraft: false,
                  createdAt: DateTime.now(),
                  updatedAt: DateTime.now(),
                );
          return CollagePublishScreen(collage: collage);
        },
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const PublicProfileScreen(),
      ),
      GoRoute(
        path: '/profile/edit',
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: '/profile/settings',
        builder: (context, state) => const AccountSettingsScreen(),
      ),
      GoRoute(
        path: '/profile/settings/account-management',
        builder: (context, state) => const AccountManagementScreen(),
      ),
      GoRoute(
        path: '/profile/settings/personal-information',
        builder: (context, state) => const PersonalInformationScreen(),
      ),
      GoRoute(
        path: '/profile/settings/gender',
        builder: (context, state) => const GenderSettingsScreen(),
      ),
      GoRoute(
        path: '/profile/settings/country',
        builder: (context, state) => const CountryRegionScreen(),
      ),
      GoRoute(
        path: '/profile/settings/language',
        builder: (context, state) => const LanguageScreen(),
      ),
      GoRoute(
        path: '/profile/settings/birthdate',
        builder: (context, state) => const BirthdateSettingsScreen(),
      ),
      GoRoute(
        path: '/profile/settings/convert-business',
        builder: (context, state) => const ConvertBusinessAccountScreen(),
      ),
      GoRoute(
        path: '/profile/settings/deactivate',
        builder: (context, state) => const DeactivateAccountScreen(),
      ),
      GoRoute(
        path: '/profile/settings/delete-account',
        builder: (context, state) => const DeleteAccountScreen(),
      ),
      GoRoute(
        path: '/profile/settings/change-password',
        builder: (context, state) => const ChangePasswordScreen(),
      ),
      GoRoute(
        path: '/profile/settings/security-logins',
        builder: (context, state) => const SecurityLoginsScreen(),
      ),
      GoRoute(
        path: '/profile/settings/login-options',
        builder: (context, state) => const LoginOptionsScreen(),
      ),
      GoRoute(
        path: '/profile/settings/add-account',
        builder: (context, state) => const AddAccountScreen(),
      ),
      GoRoute(
        path: '/profile/settings/refine-recommendations',
        builder: (context, state) => const RefineRecommendationsScreen(),
      ),
      GoRoute(
        path: '/profile/settings/profile-visibility',
        builder: (context, state) => const ProfileVisibilityScreen(),
      ),
      GoRoute(
        path: '/profile/settings/social-permissions',
        builder: (context, state) => const SocialPermissionsScreen(),
      ),
      GoRoute(
        path: '/profile/settings/link-instagram',
        builder: (context, state) => const ClaimInstagramScreen(),
      ),
      GoRoute(
        path: '/profile/settings/notifications',
        builder: (context, state) => const NotificationsSettingsScreen(),
      ),
      GoRoute(
        path: '/profile/settings/privacy-data',
        builder: (context, state) => const PrivacyDataScreen(),
      ),
      GoRoute(
        path: '/profile/settings/reports-violations',
        builder: (context, state) => const ReportsViolationsScreen(),
      ),
      GoRoute(
        path: '/profile/collection',
        builder: (context, state) => const ProfileCollectionScreen(),
      ),
    ],
  );

  ref.onDispose(router.dispose);
  return router;
});
