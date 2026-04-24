import 'package:flutter_test/flutter_test.dart';

import 'package:pinterest_clone/main.dart';

void main() {
  testWidgets('auth landing screen renders', (tester) async {
    await tester.pumpWidget(const PinterestCloneApp());
    await tester.pump();

    expect(find.text('Create a life\nyou love'), findsOneWidget);
    expect(find.text('Continue'), findsOneWidget);
    expect(find.text('Continue with Google'), findsOneWidget);
  });
}
