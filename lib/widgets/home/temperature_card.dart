import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fishingapp/services/weather_service.dart';

class TemperatureCard extends StatelessWidget {
  final String currentLocation;
  final List<HourlyWeather> hourlyWeatherList;

  TemperatureCard({required this.currentLocation, required this.hourlyWeatherList});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth * 0.9; // Adjust as needed

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
              // Current Location
              Text(
                currentLocation,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 10), // Add some spacing below the location

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minWidth: cardWidth),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (var i = 0; i < hourlyWeatherList.length; i++)
                        Padding(
                          padding: EdgeInsets.only(right: 20.0),
                          child: _buildWeatherColumn(i),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeatherColumn(int index) {
    return DecoratedBox(
      decoration: index == 0
          ? BoxDecoration(
              border: Border.all(
                color: Colors.white.withOpacity(0.5), // Light gray border color
                width: 1, // Border width
              ),
              borderRadius: BorderRadius.circular(15),
            )
          : BoxDecoration(),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Time (Day and Month)
            Text(
              _getTimeText(index),
              style: TextStyle(
                fontSize: 14,
                color: index == 0 ? Colors.grey.withOpacity(0.5) : Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            // Temperature
            Icon(
              Icons.wb_sunny,
              color: Colors.orange,
              size: 30, // Smaller icon size
            ),
            SizedBox(height: 5),
            Text(
              '${hourlyWeatherList[index].temperature.toStringAsFixed(1)}°C',
              style: TextStyle(
                fontSize: 14, // Smaller font size
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            // SizedBox(height: 5),
            // // Humidity
            // Icon(
            //   Icons.water,
            //   color: Colors.blue,
            //   size: 30, // Smaller icon size
            // ),
            // SizedBox(height: 5),
            // Text(
            //   '${hourlyWeatherList[index].humidity.toStringAsFixed(1)}%',
            //   style: TextStyle(
            //     fontSize: 14, // Smaller font size
            //     color: Colors.white,
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),
            SizedBox(height: 5),
            // Wind Speed
            Icon(
              Icons.air,
              color: Colors.grey,
              size: 30, // Smaller icon size
            ),
            SizedBox(height: 5),
            Text(
              '${hourlyWeatherList[index].windSpeed.toStringAsFixed(1)} m/s',
              style: TextStyle(
                fontSize: 14, // Smaller font size
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getTimeText(int index) {
    if (index == 0) {
      return 'Now';
    } else {
      // Assuming hourlyWeatherList contains 'hourlyWeather' objects with a 'time' property
      return _parseTime(hourlyWeatherList[index].time);
    }
  }

  String _parseTime(String timeString) {
    DateTime dateTime = DateTime.parse(timeString);
    return DateFormat('MMM d').format(dateTime); // Example: "May 14"
  }
}
