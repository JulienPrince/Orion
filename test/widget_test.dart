import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_app/app/app.dart';

void main() {
  testWidgets('HermesApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const HermesApp());
    expect(find.byType(HermesApp), findsOneWidget);
  });
}
