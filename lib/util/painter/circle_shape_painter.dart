import 'dart:math' as math;

import 'package:flutter/cupertino.dart';

class CircleShapePainter extends CustomPainter {
  CircleShapePainter({required this.radius, required this.color});

  final double radius;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = color;

    var rect = Offset.zero & size;
    canvas.drawArc(
      Rect.fromCircle(
          center: Offset(rect.topRight.dx - 30, rect.topRight.dy + 30),
          radius: radius),
      math.pi * 2,
      math.pi * 2,
      true,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
