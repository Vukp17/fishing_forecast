import 'package:fishingapp/models/weather_model.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WeatherChart extends StatefulWidget {
  final List<WeatherData> data;
  final String parameter;

  WeatherChart({required this.data, required this.parameter});

  @override
  _WeatherChartState createState() => _WeatherChartState();
}

class _WeatherChartState extends State<WeatherChart> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollLeft() {
    _scrollController.animateTo(
      _scrollController.offset - 100,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _scrollRight() {
    _scrollController.animateTo(
      _scrollController.offset + 100,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Process data
    List<FlSpot> spots = processData(widget.data, widget.parameter);

    // Calculate chart width dynamically
    double chartWidth = MediaQuery.of(context).size.width * (spots.length / 10);

    return Stack(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          controller: _scrollController,
          child: SizedBox(
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
                extraLinesData: ExtraLinesData(
                  verticalLines: [
                    VerticalLine(
                      x: getSunriseXValue(widget.data),
                      color: Colors.orange,
                      strokeWidth: 1,
                      label: VerticalLineLabel(
                        show: true,
                        labelResolver: (line) => 'Sunrise',
                      ),
                    ),
                    VerticalLine(
                      x: getSunsetXValue(widget.data),
                      color: Colors.red,
                      strokeWidth: 1,
                      label: VerticalLineLabel(
                        show: true,
                        labelResolver: (line) => 'Sunset',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          left: 0,
          top: 0,
          bottom: 0,
          child: GestureDetector(
            onTap: _scrollLeft,
            child: Container(
              alignment: Alignment.centerLeft,
              color: Colors.transparent, // Make sure the container is clickable
              child: const Icon(Icons.arrow_back, color: Colors.grey),
            ),
          ),
        ),
        Positioned(
          right: 0,
          top: 0,
          bottom: 0,
          child: GestureDetector(
            onTap: _scrollRight,
            child: Container(
              alignment: Alignment.centerRight,
              color: Colors.transparent, // Make sure the container is clickable
              child: const Icon(Icons.arrow_forward, color: Colors.grey),
            ),
          ),
        ),
      ],
    );
  }

  List<FlSpot> processData(List<WeatherData> data, String parameter) {
    List<FlSpot> spots = [];
    switch (parameter) {
      case 'Temperature' || 'Temperatura':
        spots = data
            .map((weather) => FlSpot(
                weather.date.millisecondsSinceEpoch.toDouble(),
                weather.temperature))
            .toList();
        break;

      case 'Wind Speed' || 'Hitrost vetra' || 'Brzina vjetra' || 'Brzina vetra':
        spots = data
            .map((weather) => FlSpot(
                weather.date.millisecondsSinceEpoch.toDouble(),
                weather.windSpeed))
            .toList();
        break;
      case 'Humidity' || 'Vlažnost' || 'Vlažnost zraka' || 'Vlažnost zraka':
        spots = data
            .map((weather) => FlSpot(
                weather.date.millisecondsSinceEpoch.toDouble(),
                weather.relative_humidity))
            .toList();
        break;
      default:
        spots = [];
    }
    return spots;
  }

  double getSunriseXValue(List<WeatherData> data) {
    WeatherData firstData = data.firstWhere((weather) => weather.sunrise.isNotEmpty, orElse: () => data.first);
    return firstData.sunrise.isNotEmpty ? DateTime.parse(firstData.sunrise as String).millisecondsSinceEpoch.toDouble() : 0;
  }
  
  double getSunsetXValue(List<WeatherData> data) {
    WeatherData firstData = data.firstWhere((weather) => weather.sunset.isNotEmpty, orElse: () => data.first);
    return firstData.sunset.isNotEmpty ? DateTime.parse(firstData.sunset as String).millisecondsSinceEpoch.toDouble() : 0;
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
