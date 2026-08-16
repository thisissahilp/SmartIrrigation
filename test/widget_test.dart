import 'package:flutter_test/flutter_test.dart';
import 'package:smart_farm/main.dart';

void main() {
  testWidgets('Smoke test - Verify Smart Farm renders', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const SmartFarmApp());

    // Verify that the title is displayed.
    expect(find.text('SMART FARM'), findsOneWidget);
  });
}
