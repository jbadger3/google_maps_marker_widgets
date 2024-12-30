import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

///A location puck widget.
///
///By default shows the standard blue dot inside a white circle.
///Setting [showHeading] to true displays a semitransparent blue arc to indicate the current heading.
///
///Setting [showAccuracyRing] to true displays a light blue ring representing the accuracy of the
///GPS location.
class LocationPuck extends StatelessWidget {
  const LocationPuck(
      {this.puckRadius = 10,
      this.innerPuckRadius = 7.5,
      this.showHeading = false,
      this.showAccuracyRing = false,
      this.accuracyRingRadius = 30,
      super.key});

  ///The radius of this location puck.
  final double puckRadius;

  ///The inner radius (blue portion) of this location puck.
  final double innerPuckRadius;

  ///Whether the heading indicator should be shown.
  final bool showHeading;

  ///Whether the accuracy ring should be shown.
  final bool showAccuracyRing;

  ///The radius to use for representing the accuracy of the current GPS location.
  final double accuracyRingRadius;
  @override
  Widget build(BuildContext context) {
    double headingSize = showHeading ? puckRadius * 8 : puckRadius;
    double accuracyRingSize = showAccuracyRing ? accuracyRingRadius * 2.1 : 1;
    double sizeDim = max(headingSize, accuracyRingSize);
    Size size = Size(sizeDim, sizeDim);
    return CustomPaint(
        painter: LocationPuckPainter(
            puckRadius: puckRadius,
            innerPuckRadius: innerPuckRadius,
            showHeading: showHeading,
            showAccuracyRing: showAccuracyRing,
            accuracyRingRadius: accuracyRingRadius),
        size: size);
  }
}

///Painter for the [LocationPuck].
class LocationPuckPainter extends CustomPainter {
  double puckRadius;
  double innerPuckRadius;
  bool showHeading;
  bool showAccuracyRing;
  double accuracyRingRadius;

  LocationPuckPainter(
      {required this.showHeading,
      required this.puckRadius,
      required this.innerPuckRadius,
      required this.showAccuracyRing,
      required this.accuracyRingRadius});
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    if (showAccuracyRing) {
      final Paint paintAccuracyCircle = Paint()
        ..color = const Color.fromARGB(67, 134, 197, 248)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(center, accuracyRingRadius, paintAccuracyCircle);

      final Paint paintRing = Paint()
        ..strokeWidth = 0.5
        ..color = const Color.fromARGB(99, 100, 156, 253)
        ..style = PaintingStyle.stroke;
      canvas.drawCircle(center, accuracyRingRadius, paintRing);
    }

    if (showHeading) {
      final headingRadius = size.width / 2;
      final Paint paint = Paint()
        ..isAntiAlias = true
        ..strokeWidth = 3.0
        ..style = PaintingStyle.fill
        ..shader = ui.Gradient.radial(
          center,
          headingRadius,
          [
            const Color.fromARGB(154, 33, 149, 243),
            Color.fromARGB(0, 255, 255, 255)
          ],
          [0.6, 1.0],
          TileMode.clamp,
          null,
        );
      final arcRect = Rect.fromCircle(
          center: Offset(size.width / 2, size.height / 2),
          radius: size.width / 2);
      final useCenter = true;
      final sweepAngle = 360 / 6 / 360 * 2 * pi;
      final startAngle = sweepAngle * 4;

      canvas.drawArc(arcRect, startAngle, sweepAngle, useCenter, paint);
    }

    final outerCirclePaint = Paint()
      ..isAntiAlias = true
      ..color = Colors.white;

    canvas.drawCircle(center, puckRadius, outerCirclePaint);

    final locationPuckInnerCircleRadius = innerPuckRadius;
    final innerCirclePaint = Paint()
      ..isAntiAlias = true
      ..color = Colors.blue;
    canvas.drawCircle(center, locationPuckInnerCircleRadius, innerCirclePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
