import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cryptingtool/main.dart';

void main() {
  testWidgets('App should display title and input field', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the app title is displayed
    expect(find.text('CryptingTool - Flutter/C++'), findsOneWidget);
    
    // Verify that the input field exists
    expect(find.byType(TextField), findsOneWidget);
    
    // Verify that the encrypt button exists
    expect(find.text('Encrypt with C++'), findsOneWidget);
  });

  testWidgets('Should show result after encryption', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Enter text in the input field
    await tester.enterText(find.byType(TextField), 'test');
    
    // Tap the encrypt button
    await tester.tap(find.text('Encrypt with C++'));
    await tester.pump();

    // Verify that some result is shown (either encrypted text or error)
    expect(find.textContaining('Encrypted:'), findsOneWidget);
  });
}