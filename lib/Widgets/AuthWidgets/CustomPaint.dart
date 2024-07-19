import 'dart:math';
import 'package:flutter/material.dart';

class DottedBackgroundPainter extends CustomPainter {
  final double dotSpacing;
  final double initialDotRadius;
  final Color dotColor;

  DottedBackgroundPainter({
    this.dotSpacing = 40,
    this.initialDotRadius = 20,
    this.dotColor = const Color.fromARGB(255, 255, 215, 215),
  });

  @override
  void paint(Canvas canvas, Size size) {
    double maxDistance =
        sqrt(size.width * size.width + size.height * size.height);

    for (double y = 0; y < size.height; y += dotSpacing) {
      if (y < 50) {
        continue;
      }
      for (double x = 0; x < size.width; x += dotSpacing) {
        double distanceFromTopLeft = sqrt(x * x + y * y);
        double distanceFromBottomRight = sqrt(
            (size.width - x) * (size.width - x) +
                (size.height - y) * (size.height - y));

        double progressTopLeft = distanceFromTopLeft / maxDistance;
        double progressBottomRight = distanceFromBottomRight / maxDistance;

        double opacity = 1 - max(progressTopLeft, progressBottomRight);
        double dotRadius =
            initialDotRadius * (1 - max(progressTopLeft, progressBottomRight));

        final paint = Paint()
          ..color = dotColor.withOpacity(opacity)
          ..style = PaintingStyle.fill;

        canvas.drawCircle(Offset(x, y), dotRadius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
