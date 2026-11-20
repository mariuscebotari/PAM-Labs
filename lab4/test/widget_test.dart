import 'package:flutter_test/flutter_test.dart';
import 'package:gem_store_lab4/main.dart';

void main() {
  testWidgets('GemStore app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify app starts
    expect(find.byType(MyApp), findsOneWidget);
  });
}
