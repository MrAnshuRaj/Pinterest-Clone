import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pinterest_clone/features/auth/presentation/screens/auth_landing_screen.dart';

void main() {
  testWidgets('auth landing screen renders', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: AuthLandingScreen())),
    );
    await tester.pump();

    expect(find.text('Create a life\nyou love'), findsOneWidget);
    expect(find.text('Continue'), findsOneWidget);
    expect(find.text('Continue with Google'), findsOneWidget);
  });
}
