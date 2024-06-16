import 'package:fishingapp/models/weather_model.dart';
import 'package:fishingapp/services/api_contant.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
      final apiUrl =
          '$WEATHER_URL';
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

  Future<List<WeatherData>> fetchWeatherData(String latitude, String longitude, DateTime date) async {
    final response = await http.get(Uri.parse('$apiUrl?latitude=$latitude&longitude=$longitude&hourly=temperature_2m,wind_speed_10m'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> hourlyTemperature = data['hourly']['temperature_2m'];
      final List<dynamic> hourlyWindSpeed = data['hourly']['wind_speed_10m'];
      final List<dynamic> hourlyTime = data['hourly']['time'];

      List<WeatherData> weatherDataList = [];
      for (var i = 0; i < hourlyTime.length; i++) {
        DateTime weatherDate = DateTime.parse(hourlyTime[i]);
        if (weatherDate.year == date.year && weatherDate.month == date.month && weatherDate.day == date.day) {
          weatherDataList.add(WeatherData.fromJson({
            'date': hourlyTime[i],
            'temperature': hourlyTemperature[i],
            'wind_speed': hourlyWindSpeed[i],
            'moon_phase': 'unknown', // Replace this with actual data if available
            'fish_forecast': 0.0 // Replace this with actual calculation if available
          }));
        }
      }

      return weatherDataList;
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}
