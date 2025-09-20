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

      // Build the widget in a test environment
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: icon,
            ),
          ),
        ),
      );

      // Verify the widget itself is rendered, not just its CustomPaint component
      expect(find.byType(CpuChipIcon), findsOneWidget);
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

      // Verify the widget is rendered with the correct size property
      expect(find.byType(CpuChipIcon), findsOneWidget);
      
      // Check if the CpuChipIcon widget has the correct size
      final cpuIconWidget = tester.widget<CpuChipIcon>(find.byType(CpuChipIcon));
      expect(cpuIconWidget.size, equals(64));
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

      // Verify the widget is rendered and check its glowColor property
      expect(find.byType(CpuChipIcon), findsOneWidget);
      final cpuIconWidget = tester.widget<CpuChipIcon>(find.byType(CpuChipIcon));
      expect(cpuIconWidget.glowColor, equals(AppTheme.cyanAccent));
    });
  });
}