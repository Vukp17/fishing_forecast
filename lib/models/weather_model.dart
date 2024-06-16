class WeatherData {
  final DateTime date;
  final double temperature;
  final double windSpeed;
  final String moonPhase;
  final double fishForecast;

  WeatherData({
    required this.date,
    required this.temperature,
    required this.windSpeed,
    required this.moonPhase,
    required this.fishForecast,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      date: DateTime.parse(json['date']),
      temperature: json['temperature'].toDouble(),
      windSpeed: json['wind_speed'].toDouble(),
      moonPhase: json['moon_phase'],
      fishForecast: json['fish_forecast'].toDouble(),
    );
  }
}
