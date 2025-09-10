import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';
import '../theme/app_theme.dart';

/// Custom widget to display the CPU chip app icon with keyhole symbol
/// Renders an SVG-style icon using custom painting
class CpuChipIcon extends StatelessWidget {
  final double size;
  final Color? glowColor;
  final bool showGlow;

  const CpuChipIcon({
    super.key,
    this.size = 32,
    this.glowColor,
    this.showGlow = true,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: CpuChipPainter(
        glowColor: glowColor ?? AppTheme.tealAccent,
        showGlow: showGlow,
      ),
    );
  }
}

class CpuChipPainter extends CustomPainter {
  final Color glowColor;
  final bool showGlow;

  CpuChipPainter({
    required this.glowColor,
    this.showGlow = true,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final chipSize = size.width * 0.6;
    final pinSize = size.width * 0.03;
    
    // Background (dark)
    final backgroundPaint = Paint()
      ..color = AppTheme.deepOffBlack
      ..style = PaintingStyle.fill;
    
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), backgroundPaint);
    
    // Draw circuit board traces (subtle background)
    _drawCircuitTraces(canvas, size);
    
    // CPU pins
    _drawCpuPins(canvas, centerX, centerY, chipSize, pinSize);
    
    // CPU main body
    _drawCpuBody(canvas, centerX, centerY, chipSize);
    
    // Central keyhole symbol
    _drawKeyhole(canvas, centerX, centerY, chipSize);
  }
  
  void _drawCircuitTraces(Canvas canvas, Size size) {
    final tracePaint = Paint()
      ..color = glowColor.withOpacity(0.3)
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;
    
    // Simple circuit traces
    final third = size.width / 3;
    
    // Horizontal lines
    canvas.drawLine(
      Offset(0, third),
      Offset(size.width, third),
      tracePaint,
    );
    canvas.drawLine(
      Offset(0, third * 2),
      Offset(size.width, third * 2),
      tracePaint,
    );
    
    // Vertical lines
    canvas.drawLine(
      Offset(third, 0),
      Offset(third, size.height),
      tracePaint,
    );
    canvas.drawLine(
      Offset(third * 2, 0),
      Offset(third * 2, size.height),
      tracePaint,
    );
    
    // Circuit nodes
    final nodePaint = Paint()
      ..color = glowColor.withOpacity(0.5)
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(Offset(third, third), 1, nodePaint);
    canvas.drawCircle(Offset(third * 2, third), 1, nodePaint);
    canvas.drawCircle(Offset(third, third * 2), 1, nodePaint);
    canvas.drawCircle(Offset(third * 2, third * 2), 1, nodePaint);
  }
  
  void _drawCpuPins(Canvas canvas, double centerX, double centerY, double chipSize, double pinSize) {
    final pinPaint = Paint()
      ..color = AppTheme.mediumGray
      ..style = PaintingStyle.fill;
    
    final pinSpacing = chipSize * 0.12;
    final pinLength = chipSize * 0.15;
    final halfChip = chipSize / 2;
    
    // Top and bottom pins
    for (int i = -3; i <= 3; i++) {
      final x = centerX + (i * pinSpacing);
      
      // Top pins
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(x, centerY - halfChip - pinLength/2),
            width: pinSize,
            height: pinLength,
          ),
          const Radius.circular(1),
        ),
        pinPaint,
      );
      
      // Bottom pins
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(x, centerY + halfChip + pinLength/2),
            width: pinSize,
            height: pinLength,
          ),
          const Radius.circular(1),
        ),
        pinPaint,
      );
    }
    
    // Left and right pins
    for (int i = -2; i <= 2; i++) {
      final y = centerY + (i * pinSpacing);
      
      // Left pins
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(centerX - halfChip - pinLength/2, y),
            width: pinLength,
            height: pinSize,
          ),
          const Radius.circular(1),
        ),
        pinPaint,
      );
      
      // Right pins
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(centerX + halfChip + pinLength/2, y),
            width: pinLength,
            height: pinSize,
          ),
          const Radius.circular(1),
        ),
        pinPaint,
      );
    }
  }
  
  void _drawCpuBody(Canvas canvas, double centerX, double centerY, double chipSize) {
    final chipBodyPaint = Paint()
      ..shader = ui.Gradient.radial(
        Offset(centerX, centerY),
        chipSize / 2,
        [
          AppTheme.darkGray,
          AppTheme.deepOffBlack.withOpacity(0.8),
        ],
        [0.0, 1.0],
      )
      ..style = PaintingStyle.fill;
    
    final chipOutlinePaint = Paint()
      ..color = glowColor
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    
    // CPU body with glow effect
    if (showGlow) {
      final glowPaint = Paint()
        ..color = glowColor.withOpacity(0.3)
        ..strokeWidth = 3
        ..style = PaintingStyle.stroke
        ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 2);
      
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(centerX, centerY),
            width: chipSize,
            height: chipSize,
          ),
          const Radius.circular(4),
        ),
        glowPaint,
      );
    }
    
    // Main chip body
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(centerX, centerY),
          width: chipSize,
          height: chipSize,
        ),
        const Radius.circular(4),
      ),
      chipBodyPaint,
    );
    
    // Chip outline
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(centerX, centerY),
          width: chipSize,
          height: chipSize,
        ),
        const Radius.circular(4),
      ),
      chipOutlinePaint,
    );
    
    // Inner detail lines
    final detailPaint = Paint()
      ..color = AppTheme.mediumGray.withOpacity(0.6)
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;
    
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(centerX, centerY),
          width: chipSize * 0.8,
          height: chipSize * 0.8,
        ),
        const Radius.circular(3),
      ),
      detailPaint,
    );
  }
  
  void _drawKeyhole(Canvas canvas, double centerX, double centerY, double chipSize) {
    final keyholeSize = chipSize * 0.25;
    final keyholeCenter = Offset(centerX, centerY - keyholeSize * 0.1);
    
    // Keyhole glow background
    if (showGlow) {
      final glowPaint = Paint()
        ..shader = ui.Gradient.radial(
          keyholeCenter,
          keyholeSize,
          [
            glowColor.withOpacity(0.6),
            glowColor.withOpacity(0.3),
            glowColor.withOpacity(0.1),
            Colors.transparent,
          ],
          [0.0, 0.4, 0.7, 1.0],
        )
        ..style = PaintingStyle.fill;
      
      canvas.drawCircle(keyholeCenter, keyholeSize, glowPaint);
    }
    
    // Keyhole circle (top part)
    final keyholeCirclePaint = Paint()
      ..color = glowColor
      ..style = PaintingStyle.fill;
    
    final keyholeHolePaint = Paint()
      ..color = AppTheme.deepOffBlack
      ..style = PaintingStyle.fill;
    
    // Main keyhole circle
    canvas.drawCircle(keyholeCenter, keyholeSize * 0.4, keyholeCirclePaint);
    canvas.drawCircle(keyholeCenter, keyholeSize * 0.28, keyholeHolePaint);
    
    // Keyhole slot (bottom part)
    final slotWidth = keyholeSize * 0.25;
    final slotHeight = keyholeSize * 0.5;
    final slotRect = Rect.fromCenter(
      center: Offset(keyholeCenter.dx, keyholeCenter.dy + keyholeSize * 0.35),
      width: slotWidth,
      height: slotHeight,
    );
    
    canvas.drawRRect(
      RRect.fromRectAndRadius(slotRect, const Radius.circular(1)),
      keyholeCirclePaint,
    );
    
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: slotRect.center,
          width: slotWidth * 0.6,
          height: slotHeight * 0.8,
        ),
        const Radius.circular(0.5),
      ),
      keyholeHolePaint,
    );
    
    // Additional glow rings
    if (showGlow) {
      final glowRingPaint = Paint()
        ..color = glowColor.withOpacity(0.4)
        ..strokeWidth = 1
        ..style = PaintingStyle.stroke;
      
      canvas.drawCircle(keyholeCenter, keyholeSize * 0.55, glowRingPaint);
      
      final outerGlowPaint = Paint()
        ..color = AppTheme.cyanAccent.withOpacity(0.3)
        ..strokeWidth = 0.5
        ..style = PaintingStyle.stroke;
      
      canvas.drawCircle(keyholeCenter, keyholeSize * 0.7, outerGlowPaint);
    }
  }

  @override
  bool shouldRepaint(CpuChipPainter oldDelegate) {
    return oldDelegate.glowColor != glowColor || oldDelegate.showGlow != showGlow;
  }
}