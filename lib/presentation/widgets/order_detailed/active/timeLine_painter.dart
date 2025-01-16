import 'package:flutter/material.dart';

class TimelineProgressPainter extends CustomPainter {
  final Animation<double> animation;
  final List<String> stateOrder;
  final String currentActiveState;
  final Color lineColor;

  TimelineProgressPainter({
    required this.animation,
    required this.stateOrder,
    required this.currentActiveState,
    required this.lineColor,
  }) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    final currentStateIndex = stateOrder.indexOf(currentActiveState);

    final animatedHeight = 12 +
        (size.height - 24) *
            animation.value *
            (currentStateIndex / (stateOrder.length - 1));

    canvas.drawLine(
      Offset(30, 12),
      Offset(30, animatedHeight),
      paint,
    );
  }

  @override
  bool shouldRepaint(TimelineProgressPainter oldDelegate) => true;
}

