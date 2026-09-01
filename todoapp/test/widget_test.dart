import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:todoapp/main.dart';

void main() {
  testWidgets('Todo app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const TodoApp());

    // Just verify the app builds and shows something,
    // e.g. an empty state or an AppBar title.
    expect(find.byType(TodoApp), findsOneWidget);
  });
}