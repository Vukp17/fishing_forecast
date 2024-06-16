import 'package:fishingapp/models/weather_model.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class WeatherChart extends StatelessWidget {
  final List<WeatherData> data;
  final String parameter;

  WeatherChart({required this.data, required this.parameter});

  @override
  Widget build(BuildContext context) {
    List<FlSpot> spots = [];

    switch (parameter) {
      case 'Temperature':
        spots = data
            .map((weather) => FlSpot(
                weather.date.millisecondsSinceEpoch.toDouble(),
                weather.temperature))
            .toList();
        break;
      case 'Wind Speed':
        spots = data
            .map((weather) => FlSpot(
                weather.date.millisecondsSinceEpoch.toDouble(),
                weather.windSpeed))
            .toList();
        break;
      case 'Moon Phase':
        // Handle moon phase data (convert to numerical if necessary)
        break;
      case 'Fish Forecast':
        spots = data
            .map((weather) => FlSpot(
                weather.date.millisecondsSinceEpoch.toDouble(),
                weather.fishForecast))
            .toList();
        break;
      default:
        spots = [];
    }

    return LineChart(
      LineChartData(
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: Colors.blue,
            barWidth: 2,
            belowBarData: BarAreaData(show: true),
          ),
        ],
        titlesData: const FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: bottomTitlesWidgets,
            ),
          ),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),

        ),
        gridData: FlGridData(show: false, drawHorizontalLine: true),
        backgroundColor: Colors.white,
        borderData: FlBorderData(show: false),
      ),
    );
  }
}

Widget bottomTitlesWidgets(double value, TitleMeta meta) {
  final date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
  return Text('${date.hour}');
}
