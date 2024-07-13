import 'package:fishingapp/models/weather_model.dart';
import 'package:fishingapp/services/api_contant.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';

class HourlyWeather {
  final String time;
  final double temperature;
  final double humidity;
  final double windSpeed;

  HourlyWeather({
    required this.time,
    required this.temperature,
    required this.humidity,
    required this.windSpeed,
  });
}

class WeatherService {
  static Future<List<HourlyWeather>> fetchHourlyWeather() async {
    try {
      final apiUrl = '$WEATHER_URL';
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final hourlyData = jsonData['hourly'];

        List<HourlyWeather> hourlyWeatherList = [];
        DateTime now = DateTime.now();
        int currentHour = now.hour;

        for (int i = 0; i < hourlyData['time'].length; i++) {
          DateTime time = DateTime.parse(hourlyData['time'][i]);

          // Only add data for the current hour for the next 5 days
          if (time.hour == currentHour && time.difference(now).inDays <= 4) {
            // print('Temperature Length: ${hourlyData['temperature_2m'].length}, '
            //     'Time Length: ${hourlyData['time'].length}, '
            //     'Humidity Length: ${hourlyData['relative_humidity_2m'].length}, '
            //     'Wind Speed Length: ${hourlyData['wind_speed_10m'].length}');
            hourlyWeatherList.add(
              HourlyWeather(
                time: hourlyData['time'][i],
                temperature: hourlyData['temperature_2m'][i],
                humidity: 22,
                windSpeed: hourlyData['wind_speed_10m'][i],
              ),
            );
          }
        }

        return hourlyWeatherList;
      } else {
        print('Alot of errors');
        return []; // Default value
      }
    } catch (error) {
      return []; // Default value
    }
  }

  final String apiUrl = 'https://api.open-meteo.com/v1/forecast';

  Future<List<WeatherData>> fetchWeatherData(
      String latitude, String longitude, DateTime startDate) async {
    DateTime endDate = startDate.add(const Duration(days: 7));
    String formattedStartDate = DateFormat('yyyy-MM-dd').format(startDate);
    String formattedEndDate = DateFormat('yyyy-MM-dd').format(endDate);
    final response = await http.get(Uri.parse(
        '$apiUrl?latitude=$latitude&longitude=$longitude&start_date=$formattedStartDate&end_date=$formattedEndDate&hourly=temperature_2m,relative_humidity_2m,wind_speed_10m&daily=sunrise,sunset'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> hourlyTemperature = data['hourly']['temperature_2m'];
      final List<dynamic> hourlyWindSpeed = data['hourly']['wind_speed_10m'];
      final List<dynamic> hourlyTime = data['hourly']['time'];
      final List<dynamic> dailySunrise = data['daily']['sunrise'];
      final List<dynamic> dailySunset = data['daily']['sunset'];
      final List<dynamic> hourlyHumidity =
          data['hourly']['relative_humidity_2m'];

      List<WeatherData> weatherDataList = [];
      for (var i = 0; i < hourlyTime.length; i++) {
        DateTime weatherDate = DateTime.parse(hourlyTime[i]);
        if (weatherDate.isAfter(startDate.subtract(const Duration(days: 1))) &&
            weatherDate.isBefore(endDate.add(const Duration(days: 1)))) {
          // Match sunrise and sunset times for the current date
          String sunrise = dailySunrise.firstWhere(
            (element) => DateTime.parse(element).day == weatherDate.day,
            orElse: () => '',
          );
          String sunset = dailySunset.firstWhere(
            (element) => DateTime.parse(element).day == weatherDate.day,
            orElse: () => '',
          );

          weatherDataList.add(WeatherData.fromJson({
            'date': hourlyTime[i],
            'temperature': hourlyTemperature[i],
            'wind_speed': hourlyWindSpeed[i],
            'sunrise': sunrise.isNotEmpty ? sunrise : null,
            'sunset': sunset.isNotEmpty ? sunset : null,
            'moon_phase': calculateMoonPhase(
                weatherDate), // Replace with actual data if available
            'fish_forecast':
                0.0, // Replace with actual calculation if available
            'relative_humidity': hourlyHumidity[i]
          }));
        }
      }

      return weatherDataList;
    } else {
      throw Exception('Failed to load weather data ${response.body}');
    }
  }

  String calculateMoonPhase(DateTime date) {
    // Reference new moon date: January 6, 2000
    DateTime newMoonReference = DateTime(2000, 1, 6);
    int daysSinceReference = date.difference(newMoonReference).inDays;

    // Synodic month length in days
    double synodicMonth = 29.53058867;

    // Calculate the phase as a fraction of the synodic month
    double phase = (daysSinceReference % synodicMonth) / synodicMonth;

    // Determine the moon phase
    if (phase < 0.03 || phase > 0.97) {
      return 'New Moon';
    } else if (phase < 0.25) {
      return 'Waxing Crescent';
    } else if (phase < 0.27) {
      return 'First Quarter';
    } else if (phase < 0.50) {
      return 'Waxing Gibbous';
    } else if (phase < 0.53) {
      return 'Full Moon';
    } else if (phase < 0.75) {
      return 'Waning Gibbous';
    } else if (phase < 0.77) {
      return 'Last Quarter';
    } else {
      return 'Waning Crescent';
    }
  }
}
