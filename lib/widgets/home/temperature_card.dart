import 'package:flutter/material.dart';

// Custom Temperature Card Widget
class TemperatureCard extends StatelessWidget {
  final double temperature;

  TemperatureCard({required this.temperature});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            colors: [
              Color(0xFF4a7484),
              Color(0xFF40d3c3),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Current Weather',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Icon(
                    Icons.wb_sunny,
                    color: Colors.orange,
                    size: 40,
                  ),
                  SizedBox(width: 10),
                  Text(
                    '${temperature.toStringAsFixed(1)}°C',
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}