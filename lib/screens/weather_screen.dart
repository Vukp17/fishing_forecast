import 'package:fishingapp/widgets/weather/sunrise_widget.dart';
import 'package:fishingapp/widgets/weather/weather_widet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/weather_service.dart';
import '../models/weather_model.dart';
import 'package:intl/intl.dart';

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late Future<List<WeatherData>> weatherData;
  String selectedParameter = 'Temperature';
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    fetchWeather();
  }

  void fetchWeather() {
    weatherData = Provider.of<WeatherService>(context, listen: false)
        .fetchWeatherData('46.5547', '15.6459', selectedDate);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        fetchWeather();
      });
    }
  }

  List<DateTime> _generateWeekDates(DateTime selectedDate) {
    final startOfWeek = selectedDate.subtract(Duration(days: selectedDate.weekday - 1));
    return List.generate(7, (index) => startOfWeek.add(Duration(days: index)));
  }

  @override
  Widget build(BuildContext context) {
    List<DateTime> weekDates = _generateWeekDates(selectedDate);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather Forecast'),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: weekDates.map((date) {
              bool isSelected = date.day == selectedDate.day && date.month == selectedDate.month && date.year == selectedDate.year;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedDate = date;
                    fetchWeather();
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.blue : Colors.transparent,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Column(
                    children: [
                      Text(DateFormat.E().format(date)),
                      Text(DateFormat.d().format(date)),
                    ],
                  ),
                ),
              );
            }).toList()
              ..add(
                GestureDetector(
                  onTap: () => _selectDate(context),
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Icon(Icons.calendar_today, color: Colors.grey),
                        Text('Calendar', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                ),
              ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.waves),
                onPressed: () => setState(() => selectedParameter = 'Temperature'),
              ),
              IconButton(
                icon: const Icon(Icons.air),
                onPressed: () => setState(() => selectedParameter = 'Wind Speed'),
              ),
              IconButton(
                icon: const Icon(Icons.nights_stay),
                onPressed: () => setState(() => selectedParameter = 'Moon Phase'),
              ),
              IconButton(
                icon: const Icon(Icons.help),
                onPressed: () => setState(() => selectedParameter = 'Fish Forecast'),
              ),
            ],
          ),
          Expanded(
            child: FutureBuilder<List<WeatherData>>(
              future: weatherData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  print(snapshot.error);
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  final weather = snapshot.data!.first;
                  return Column(
                    children: [
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          child: SunriseSunsetWidget(
                            sunrise: weather.sunrise,
                            sunset: weather.sunset,
                          ),
                        ),
                      ),
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Container(
                          height: 300, // Adjusted height for the chart
                          padding: const EdgeInsets.all(8.0),
                          child: WeatherChart(
                            data: snapshot.data!,
                            parameter: selectedParameter,
                          ),
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
