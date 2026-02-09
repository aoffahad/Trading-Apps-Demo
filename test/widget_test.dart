import 'package:flutter_test/flutter_test.dart';

import 'package:trading_apps/app.dart';

void main() {
  testWidgets('App loads', (WidgetTester tester) async {
    await tester.pumpWidget(const App());
    expect(find.text('Trading App'), findsOneWidget);
  });
}
