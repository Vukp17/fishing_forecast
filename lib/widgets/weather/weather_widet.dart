import 'package:fishingapp/models/weather_model.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class WeatherChart extends StatelessWidget {
  final List<WeatherData> data;
  final String parameter;

  WeatherChart({required this.data, required this.parameter});

  @override
  Widget build(BuildContext context) {
    // Process data
    List<FlSpot> spots = processData(data, parameter);

    // Calculate chart width dynamically
    double chartWidth = MediaQuery.of(context).size.width * (spots.length / 10);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        width: chartWidth,
        height: 300, // Set a fixed height for the chart
        child: LineChart(
          LineChartData(
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: true,
                color: Colors.blue,
                barWidth: 2,
                dotData: const FlDotData(show: false),
                belowBarData: BarAreaData(show: true, color: Colors.blue.withOpacity(0.3)),
              ),
            ],
            titlesData: const FlTitlesData(
              show: true,
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: bottomTitlesWidgets,
                  reservedSize: 30,
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 10,
                  getTitlesWidget: leftTitlesWidgets,
                  reservedSize: 30,
                  
                ),
              ),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            gridData: FlGridData(
              show: true,
              drawHorizontalLine: true,
              getDrawingHorizontalLine: (value) {
                return FlLine(
                  color: Colors.grey[300]!,
                  strokeWidth: 1,
                );
              },
            ),
            borderData: FlBorderData(
              show: true,
              border: Border.all(color: Colors.grey[300]!, width: 1),
              
            ),
            minX: spots.first.x,
            maxX: spots.last.x,
            minY: 0,
            maxY: 30,
          ),
        ),
      ),
    );
  }

  List<FlSpot> processData(List<WeatherData> data, String parameter) {
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
      default:
        spots = [];
    }
    return spots;
  }
}

Widget bottomTitlesWidgets(double value, TitleMeta meta) {
  final date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
  return Padding(
    padding: const EdgeInsets.all(4.0),
    child: Text('${date.hour}:00', style: TextStyle(color: Colors.grey[700], fontSize: 10)),
  );
}

Widget leftTitlesWidgets(double value, TitleMeta meta) {
  return Padding(
    padding: const EdgeInsets.all(4.0),
    child: Text('${value.toInt()}', style: TextStyle(color: Colors.grey[700], fontSize: 10)),
  );
}
