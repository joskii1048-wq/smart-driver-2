import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_driver_2/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const SmartDriverApp());

    // Verify that app starts without errors
    expect(find.text('Умный Водитель 2.0'), findsOneWidget);
  });
}
