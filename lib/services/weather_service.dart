import 'package:http/http.dart' as http;
import 'dart:convert';

class WeatherService {
  static Future<List<double>> fetchHourlyWeather() async {
    try {
      final apiUrl = 'https://api.open-meteo.com/v1/forecast?latitude=46.55&longitude=15.64&current=temperature_2m,wind_speed_10m&hourly=temperature_2m,relative_humidity_2m,wind_speed_10m';
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final hourlyData = jsonData['hourly']['temperature_2m'];

        return hourlyData.cast<double>().toList();
      } else {
        return [0.0]; // Default value
      }
    } catch (error) {
      return [0.0]; // Default value
    }
  } 
}
