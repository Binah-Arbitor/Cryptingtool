import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:cryptingtool/widgets/cpu_chip_icon.dart';
import 'package:cryptingtool/theme/app_theme.dart';

void main() {
  group('CpuChipIcon Widget Tests', () {
    testWidgets('CpuChipIcon renders without errors', (WidgetTester tester) async {
      // Create the widget
      const icon = CpuChipIcon(
        size: 32,
        showGlow: true,
      );

      // Build the widget
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: icon,
            ),
          ),
        ),
      );

      // Verify the widget is rendered
      expect(find.byType(CpuChipIcon), findsOneWidget);
      expect(find.byType(CustomPaint), findsOneWidget);
    });

    testWidgets('CpuChipIcon accepts different sizes', (WidgetTester tester) async {
      const icon = CpuChipIcon(
        size: 64,
        showGlow: false,
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: icon,
            ),
          ),
        ),
      );

      // Verify the widget is rendered with correct size
      expect(find.byType(CpuChipIcon), findsOneWidget);
      
      // Check if the CustomPaint has the correct size
      final customPaint = tester.widget<CustomPaint>(find.byType(CustomPaint));
      expect(customPaint.size, equals(const Size(64, 64)));
    });

    testWidgets('CpuChipIcon accepts custom glow color', (WidgetTester tester) async {
      const icon = CpuChipIcon(
        size: 32,
        glowColor: AppTheme.cyanAccent,
        showGlow: true,
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: icon,
            ),
          ),
        ),
      );

      expect(find.byType(CpuChipIcon), findsOneWidget);
    });
  });
}