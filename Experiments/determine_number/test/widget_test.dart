// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:etermine_number/main.dart';

void main() {
  testWidgets('Number checker calculates and shows result',
      (WidgetTester tester) async {
    await tester.pumpWidget(const NumberCheckerApp());

    // Result section should not be visible before calculation
    expect(find.text('Prime'), findsNothing);

    // Enter a number
    await tester.enterText(find.byType(TextField), '121');

    // Tap the Check Number button
    await tester.tap(find.text('Check Number'));
    await tester.pump();

    // Result section should now be visible
    expect(find.text('Prime'), findsOneWidget);
    expect(find.text('Palindrome'), findsOneWidget);
    expect(find.text('Armstrong'), findsOneWidget);
  });
}
