import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import 'dart:ui' as ui;


class SunriseSunsetWidget extends StatelessWidget {
  final String sunrise;
  final String sunset;

  SunriseSunsetWidget({required this.sunrise, required this.sunset});

  @override
  Widget build(BuildContext context) {
    DateTime sunriseTime = DateTime.parse(sunrise);
    DateTime sunsetTime = DateTime.parse(sunset);

    return Column(
      children: [
        CustomPaint(
          size: const Size(300, 150),
          painter: SunriseSunsetPainter(sunriseTime, sunsetTime),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.wb_sunny, color: Colors.orange),
                const SizedBox(width: 8),
                Text('Sunrise: ${DateFormat('hh:mm a').format(sunriseTime)}'),
              ],
            ),
            Row(
              children: [
                const Icon(Icons.wb_sunny_outlined, color: Colors.orange),
                const SizedBox(width: 8),
                Text('Sunset: ${DateFormat('hh:mm a').format(sunsetTime)}'),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class SunriseSunsetPainter extends CustomPainter {
  final DateTime sunrise;
  final DateTime sunset;

  SunriseSunsetPainter(this.sunrise, this.sunset);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.orange
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    final sunriseAngle = _getAngle(sunrise);
    final sunsetAngle = _getAngle(sunset);

    final center = Offset(size.width / 2, size.height);
    final radius = size.width / 2;

    // Draw the half-circle
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      pi,
      pi,
      false,
      paint,
    );

    // Draw sunrise and sunset times
    _drawSunTime(canvas, center, radius, sunriseAngle, 'sunrise');
    _drawSunTime(canvas, center, radius, sunsetAngle, 'sunset');
  }

  double _getAngle(DateTime time) {
    final totalMinutes = time.hour * 60 + time.minute;
    final fractionOfDay = totalMinutes / (24 * 60);
    return fractionOfDay * 2 * pi;
  }

  void _drawSunTime(Canvas canvas, Offset center, double radius, double angle, String type) {
    final x = center.dx + radius * cos(angle);
    final y = center.dy + radius * sin(angle);

    final textPainter = TextPainter(
      text: const TextSpan(
       // text: DateFormat('hh:mm a').format(type == 'sunrise' ? sunrise : sunset),
        style: TextStyle(color: Colors.orange, fontSize: 12),
      ),
      textDirection:ui.TextDirection.ltr,
    )..layout();

    final icon = type == 'sunrise' ? Icons.wb_sunny : Icons.wb_sunny_outlined;

    final iconPainter = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(icon.codePoint),
        style: TextStyle(
          fontSize: 24,
          fontFamily: icon.fontFamily,
          color: Colors.orange,
        ),
      ),
       textDirection:ui.TextDirection.ltr,
    )..layout();

    canvas.save();
    canvas.translate(x, y);
    canvas.rotate(angle - pi / 2);
    iconPainter.paint(canvas, Offset(-iconPainter.width / 2, -iconPainter.height / 2));
    canvas.restore();

    canvas.save();
    canvas.translate(x, y + 20);
    canvas.rotate(angle - pi / 2);
    textPainter.paint(canvas, Offset(-textPainter.width / 2, 0));
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
