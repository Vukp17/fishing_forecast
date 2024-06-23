class WeatherData {
  final DateTime date;
  final double temperature;
  final double windSpeed;
  final String moonPhase;
  final double fishForecast;
  final String sunrise;
  final String sunset;

  WeatherData({
    required this.date,
    required this.temperature,
    required this.windSpeed,
    required this.moonPhase,
    required this.fishForecast,
    required this.sunrise,
    required this.sunset,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      date: DateTime.parse(json['date']),
      temperature: json['temperature'].toDouble(),
      windSpeed: json['wind_speed'].toDouble(),
      moonPhase: json['moon_phase'],
      fishForecast: json['fish_forecast'].toDouble(),
      sunrise: json['sunrise'],
      sunset: json['sunset'],
    );
  }
}
