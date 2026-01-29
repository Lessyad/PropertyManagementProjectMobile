import 'dart:ui';
import 'package:enmaa/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';

class DottedBorderContainer extends StatelessWidget {
  const DottedBorderContainer({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 12.0,
    this.borderColor = Colors.black,
    required this.child,
  });

  final double width, height;
  final double borderRadius;
  final Color borderColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.scale(width),
      height: context.scale(height),
      child: CustomPaint(
        painter: DottedBorderPainter(
          borderRadius: borderRadius,
          borderColor: borderColor,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          alignment: Alignment.center,
          child: child,
        ),
      ),
    );
  }
}

class DottedBorderPainter extends CustomPainter {
  final double borderRadius;
  final Color borderColor;

  DottedBorderPainter({required this.borderRadius, required this.borderColor});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = borderColor
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final Path path = Path();
    final RRect rRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(borderRadius),
    );

    // Create a base path with the rounded rectangle
    final Path basePath = Path()..addRRect(rRect);

    const double dashWidth = 5;
    const double dashSpace = 5;
    final PathMetrics pathMetrics = basePath.computeMetrics();

    for (PathMetric pathMetric in pathMetrics) {
      double distance = 0;
      while (distance < pathMetric.length) {
        path.addPath(
          pathMetric.extractPath(distance, distance + dashWidth),
          Offset.zero,
        );
        distance += dashWidth + dashSpace;
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}