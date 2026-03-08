import 'package:flutter/cupertino.dart';

/// CustomPainter that draws a dashed rectangular border.
class DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashLength;
  final double gapLength;
  final double borderRadius;

  const DashedBorderPainter({
    required this.color,
    this.strokeWidth = 1.5,
    this.dashLength = 6.0,
    this.gapLength = 4.0,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        strokeWidth / 2,
        strokeWidth / 2,
        size.width - strokeWidth,
        size.height - strokeWidth,
      ),
      Radius.circular(borderRadius),
    );

    final path = Path()..addRRect(rrect);
    final metrics = path.computeMetrics().first;
    final totalLength = metrics.length;

    double distance = 0;
    bool draw = true;

    while (distance < totalLength) {
      final segmentLength = draw ? dashLength : gapLength;
      if (draw) {
        final remaining = totalLength - distance;
        final end = distance + (segmentLength < remaining ? segmentLength : remaining);
        final extractedPath = metrics.extractPath(distance, end);
        canvas.drawPath(extractedPath, paint);
      }
      distance += segmentLength;
      draw = !draw;
    }
  }

  @override
  bool shouldRepaint(DashedBorderPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.dashLength != dashLength ||
        oldDelegate.gapLength != gapLength ||
        oldDelegate.borderRadius != borderRadius;
  }
}
