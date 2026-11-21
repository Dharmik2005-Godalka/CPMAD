import 'package:flutter_test/flutter_test.dart';
import 'package:first_application/main.dart' as app;

void main() 
{
  testWidgets('First app shows title and text', (WidgetTester tester) async 
  {
    app.main();
    await tester.pump();

    expect(find.text('First App'), findsOneWidget);
    expect(find.text('This is the my first application...'), findsOneWidget);
  });
}
