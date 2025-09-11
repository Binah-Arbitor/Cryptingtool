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
        glowColor: glowColor ?? AppTheme.electricBlue, // Use new blue color
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
    
    // CPU center detail (replacing keyhole)
    _drawCpuCenter(canvas, centerX, centerY, chipSize);
  }
  
  void _drawCircuitTraces(Canvas canvas, Size size) {
    // Enhanced blue-themed trace paints with multiple tones
    final primaryTracePaint = Paint()
      ..color = AppTheme.electricBlue.withOpacity(0.6)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;
    
    final secondaryTracePaint = Paint()
      ..color = AppTheme.neonBlue.withOpacity(0.5)
      ..strokeWidth = 0.9
      ..style = PaintingStyle.stroke;
    
    final thinTracePaint = Paint()
      ..color = AppTheme.cyanBlue.withOpacity(0.4)
      ..strokeWidth = 0.6
      ..style = PaintingStyle.stroke;
    
    // Asymmetrical circuit traces with enhanced complexity
    final quarter = size.width / 4;
    final third = size.width / 3;
    
    // Primary complex horizontal traces with flowing patterns
    canvas.drawPath(
      Path()
        ..moveTo(quarter * 0.6, third * 0.8)
        ..lineTo(quarter * 1.8, third * 0.8)
        ..lineTo(quarter * 1.8, third * 0.9)
        ..lineTo(quarter * 3.2, third * 0.9),
      primaryTracePaint,
    );
    
    // Add flowing curves for more organic appearance
    canvas.drawPath(
      Path()
        ..moveTo(quarter * 0.5, third * 0.6)
        ..quadraticBezierTo(quarter * 1.2, third * 0.4, quarter * 2.0, third * 0.6)
        ..quadraticBezierTo(quarter * 2.8, third * 0.8, quarter * 3.5, third * 0.7),
      secondaryTracePaint,
    );
    
    canvas.drawPath(
      Path()
        ..moveTo(0, third * 1.5)
        ..lineTo(quarter * 1.2, third * 1.5)
        ..lineTo(quarter * 1.2, third * 1.6)
        ..lineTo(quarter * 2.0, third * 1.6)
        ..lineTo(quarter * 2.0, third * 1.8)
        ..lineTo(size.width, third * 1.8),
      thinTracePaint,
    );
    
    canvas.drawPath(
      Path()
        ..moveTo(quarter * 0.8, third * 2.3)
        ..lineTo(quarter * 1.6, third * 2.3)
        ..lineTo(quarter * 1.6, third * 2.4)
        ..lineTo(quarter * 2.4, third * 2.4)
        ..lineTo(quarter * 2.4, third * 2.3)
        ..lineTo(quarter * 3.8, third * 2.3),
      primaryTracePaint,
    );
    
    // Enhanced flowing horizontal trace
    canvas.drawPath(
      Path()
        ..moveTo(0, third * 2.6)
        ..quadraticBezierTo(quarter * 1.0, third * 2.4, quarter * 2.0, third * 2.6)
        ..quadraticBezierTo(quarter * 3.0, third * 2.8, size.width, third * 2.7),
      secondaryTracePaint,
    );
    
    // Complex vertical traces
    canvas.drawPath(
      Path()
        ..moveTo(third * 0.9, 0)
        ..lineTo(third * 0.9, quarter * 0.8)
        ..lineTo(third * 1.0, quarter * 0.8)
        ..lineTo(third * 1.0, quarter * 1.5)
        ..lineTo(third * 0.9, quarter * 1.5)
        ..lineTo(third * 0.9, quarter * 2.8)
        ..lineTo(third * 1.0, quarter * 2.8)
        ..lineTo(third * 1.0, size.height),
      tracePaint,
    
    // Enhanced complex vertical traces with flowing patterns
    canvas.drawPath(
      Path()
        ..moveTo(third * 0.9, 0)
        ..lineTo(third * 0.9, quarter * 0.8)
        ..lineTo(third * 1.0, quarter * 0.8)
        ..lineTo(third * 1.0, quarter * 1.5)
        ..lineTo(third * 0.9, quarter * 1.5)
        ..lineTo(third * 0.9, quarter * 2.8)
        ..lineTo(third * 1.0, quarter * 2.8)
        ..lineTo(third * 1.0, size.height),
      primaryTracePaint,
    );
    
    // Flowing vertical trace with curves
    canvas.drawPath(
      Path()
        ..moveTo(third * 0.4, 0)
        ..quadraticBezierTo(third * 0.3, quarter * 1.0, third * 0.4, quarter * 2.0)
        ..quadraticBezierTo(third * 0.5, quarter * 3.0, third * 0.4, size.height),
      secondaryTracePaint,
    );
    
    canvas.drawPath(
      Path()
        ..moveTo(third * 1.7, quarter * 0.5)
        ..lineTo(third * 1.7, quarter * 1.2)
        ..lineTo(third * 1.8, quarter * 1.2)
        ..lineTo(third * 1.8, quarter * 1.8)
        ..lineTo(third * 1.7, quarter * 1.8)
        ..lineTo(third * 1.7, quarter * 2.5)
        ..lineTo(third * 1.8, quarter * 2.5)
        ..lineTo(third * 1.8, quarter * 3.5),
      thinTracePaint,
    );
    
    // Another flowing vertical trace
    canvas.drawPath(
      Path()
        ..moveTo(third * 2.3, 0)
        ..quadraticBezierTo(third * 2.4, quarter * 1.2, third * 2.3, quarter * 2.4)
        ..quadraticBezierTo(third * 2.2, quarter * 3.2, third * 2.3, size.height),
      primaryTracePaint,
    );
    
    // Enhanced PCB connection pads and vias with multi-colored blue theme
    final primaryNodePaint = Paint()
      ..color = AppTheme.electricBlue.withOpacity(0.9)
      ..style = PaintingStyle.fill;
      
    final secondaryNodePaint = Paint()
      ..color = AppTheme.neonBlue.withOpacity(0.8)
      ..style = PaintingStyle.fill;
      
    final accentNodePaint = Paint()
      ..color = AppTheme.cyanBlue.withOpacity(0.7)
      ..style = PaintingStyle.fill;
    
    // Varied node sizes and colors for visual interest
    canvas.drawCircle(Offset(third * 1.0, quarter * 1.1), 1.5, primaryNodePaint);
    canvas.drawCircle(Offset(third * 1.8, quarter * 2.0), 1.2, secondaryNodePaint);
    canvas.drawCircle(Offset(third * 1.8, quarter * 1.4), 1.7, accentNodePaint);
    canvas.drawCircle(Offset(quarter * 1.8, third * 2.4), 1.0, primaryNodePaint);
    canvas.drawCircle(Offset(quarter * 3.2, third * 1.8), 1.4, secondaryNodePaint);
    canvas.drawCircle(Offset(quarter * 1.2, third * 1.5), 1.1, accentNodePaint);
    canvas.drawCircle(Offset(third * 0.4, quarter * 2.0), 1.3, primaryNodePaint);
    canvas.drawCircle(Offset(third * 2.3, quarter * 1.8), 1.6, secondaryNodePaint);
    
    // Enhanced PCB component footprints with blue outlines
    final componentPaint = Paint()
      ..color = AppTheme.cyanBlue.withOpacity(0.5)
      ..strokeWidth = 0.4
      ..style = PaintingStyle.stroke;
    
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(third * 1.0, quarter * 1.2),
          width: 4,
          height: 2.5,
        ),
        const Radius.circular(0.4),
      ),
      componentPaint,
    );
    
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(third * 1.7, quarter * 1.0),
          width: 3.5,
          height: 4,
        ),
        const Radius.circular(0.4),
      ),
      componentPaint,
    );
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
    
    // Enhanced blue outline with stronger glow
    final chipOutlinePaint = Paint()
      ..color = AppTheme.electricBlue
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;
    
    // CPU body with enhanced blue glow effect
    if (showGlow) {
      final strongGlowPaint = Paint()
        ..color = AppTheme.neonBlue.withOpacity(0.4)
        ..strokeWidth = 4
        ..style = PaintingStyle.stroke
        ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 3);
      
      final mediumGlowPaint = Paint()
        ..color = AppTheme.electricBlue.withOpacity(0.3)
        ..strokeWidth = 6
        ..style = PaintingStyle.stroke
        ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 4);
      
      // Multi-layer glow for enhanced neon effect
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(centerX, centerY),
            width: chipSize,
            height: chipSize,
          ),
          const Radius.circular(4),
        ),
        mediumGlowPaint,
      );
      
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(centerX, centerY),
            width: chipSize,
            height: chipSize,
          ),
          const Radius.circular(4),
        ),
        strongGlowPaint,
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
  
  void _drawCpuCenter(Canvas canvas, double centerX, double centerY, double chipSize) {
    final centerSize = chipSize * 0.35;
    
    // CPU internal detail rectangles
    final detailPaint = Paint()
      ..color = AppTheme.mediumGray.withOpacity(0.7)
      ..strokeWidth = 0.6
      ..style = PaintingStyle.stroke;
    
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(centerX, centerY),
          width: centerSize,
          height: centerSize,
        ),
        const Radius.circular(2),
      ),
      detailPaint,
    );
    
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(centerX, centerY),
          width: centerSize * 0.8,
          height: centerSize * 0.8,
        ),
        const Radius.circular(1.5),
      ),
      detailPaint..color = AppTheme.mediumGray.withOpacity(0.6),
    );
    
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(centerX, centerY),
          width: centerSize * 0.6,
          height: centerSize * 0.6,
        ),
        const Radius.circular(1),
      ),
      detailPaint..color = AppTheme.mediumGray.withOpacity(0.5),
    );
    
    // Enhanced internal PCB traces with multi-toned blue theme
    final primaryTracePaint = Paint()
      ..color = AppTheme.neonBlue.withOpacity(0.6)
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;
      
    final secondaryTracePaint = Paint()
      ..color = AppTheme.cyanBlue.withOpacity(0.5)
      ..strokeWidth = 0.3
      ..style = PaintingStyle.stroke;
    
    final halfCenter = centerSize * 0.25;
    
    // Enhanced cross pattern traces with blue variations
    canvas.drawLine(
      Offset(centerX - halfCenter, centerY - halfCenter * 0.3),
      Offset(centerX + halfCenter, centerY - halfCenter * 0.3),
      primaryTracePaint,
    );
    canvas.drawLine(
      Offset(centerX - halfCenter * 0.3, centerY - halfCenter),
      Offset(centerX - halfCenter * 0.3, centerY + halfCenter),
      secondaryTracePaint,
    );
    canvas.drawLine(
      Offset(centerX + halfCenter * 0.3, centerY - halfCenter),
      Offset(centerX + halfCenter * 0.3, centerY + halfCenter),
      primaryTracePaint,
    );
    canvas.drawLine(
      Offset(centerX - halfCenter, centerY + halfCenter * 0.3),
      Offset(centerX + halfCenter, centerY + halfCenter * 0.3),
      secondaryTracePaint,
    );
    
    // Additional inner traces for complexity
    canvas.drawLine(
      Offset(centerX - halfCenter * 0.6, centerY - halfCenter * 0.6),
      Offset(centerX + halfCenter * 0.6, centerY + halfCenter * 0.6),
      Paint()..color = AppTheme.electricBlue.withOpacity(0.4)..strokeWidth = 0.25..style = PaintingStyle.stroke,
    );
    canvas.drawLine(
      Offset(centerX + halfCenter * 0.6, centerY - halfCenter * 0.6),
      Offset(centerX - halfCenter * 0.6, centerY + halfCenter * 0.6),
      Paint()..color = AppTheme.electricBlue.withOpacity(0.4)..strokeWidth = 0.25..style = PaintingStyle.stroke,
    );
    
    // Internal micro components
    final componentPaint = Paint()
      ..color = AppTheme.mediumGray.withOpacity(0.9)
      ..style = PaintingStyle.fill;
    
    final componentSize = centerSize * 0.08;
    final spacing = centerSize * 0.15;
    
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(centerX - spacing, centerY - spacing),
          width: componentSize,
          height: componentSize,
        ),
        const Radius.circular(0.5),
      ),
      componentPaint,
    );
    
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(centerX + spacing, centerY - spacing),
          width: componentSize,
          height: componentSize,
        ),
        const Radius.circular(0.5),
      ),
      componentPaint,
    );
    
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(centerX - spacing, centerY + spacing),
          width: componentSize,
          height: componentSize,
        ),
        const Radius.circular(0.5),
      ),
      componentPaint,
    );
    
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(centerX + spacing, centerY + spacing),
          width: componentSize,
          height: componentSize,
        ),
        const Radius.circular(0.5),
      ),
      componentPaint,
    );
  }

  @override
  bool shouldRepaint(CpuChipPainter oldDelegate) {
    return oldDelegate.glowColor != glowColor || oldDelegate.showGlow != showGlow;
  }
}