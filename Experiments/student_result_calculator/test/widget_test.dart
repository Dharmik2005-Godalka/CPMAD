// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:student_result_calculator/main.dart';

void main() {
  testWidgets('Marks input and result calculation test',
      (WidgetTester tester) async {
    await tester.pumpWidget(const ResultApp());

    // Result section should not be visible before calculation
    expect(find.text('DAA'), findsNothing);

    // Enter marks into each field
    await tester.enterText(find.byType(TextField).at(0), 'Test Student');
    await tester.enterText(find.byType(TextField).at(1), '80');
    await tester.enterText(find.byType(TextField).at(2), '70');
    await tester.enterText(find.byType(TextField).at(3), '90');
    await tester.enterText(find.byType(TextField).at(4), '60');
    await tester.enterText(find.byType(TextField).at(5), '75');

    // Tap the Calculate button
    await tester.tap(find.text('Calculate Result'));
    await tester.pump();

    // Result section should now be visible
    expect(find.text('DAA'), findsOneWidget);
    expect(find.textContaining('Percentage:'), findsOneWidget);
  });
}