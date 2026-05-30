import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soft_light/app/app.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  testWidgets('Soft light app launches', (WidgetTester tester) async {
    await tester.pumpWidget(const SoftLightApp());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Soft Light'), findsOneWidget);
    expect(find.byIcon(CupertinoIcons.lightbulb_fill), findsOneWidget);
    expect(find.byIcon(CupertinoIcons.camera_fill), findsOneWidget);
  });
}
