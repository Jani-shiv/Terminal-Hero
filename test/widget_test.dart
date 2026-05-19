import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:terminal_hero/app/terminal_hero_app.dart';

void main() {
  testWidgets('App boots to auth screen', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: TerminalHeroApp(),
      ),
    );

    expect(find.text('Terminal Hero'), findsOneWidget);
    expect(find.text('Start learning'), findsOneWidget);
  });
}
