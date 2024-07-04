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
  bool showGraph = false;

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
    final startOfWeek =
        selectedDate.subtract(Duration(days: selectedDate.weekday - 1));
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
              bool isSelected = date.day == selectedDate.day &&
                  date.month == selectedDate.month &&
                  date.year == selectedDate.year;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedDate = date;
                    fetchWeather();
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(8.0),
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
                    padding: const EdgeInsets.all(8.0),
                    child: const Column(
                      children: [
                        Icon(Icons.calendar_today, color: Colors.grey),
                        Text('Calendar', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                ),
              ),
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
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                      child: Text('No weather data available.'));
                } else {
                  final weather = snapshot.data!.first;
                  return Column(
                    children: [
                      Expanded(
                        child: ListView(
                          children: [
                            _buildParameterCard('Temperature',
                                weather.temperature, Icons.thermostat),
                            _buildParameterCard(
                                'Wind Speed', weather.windSpeed, Icons.air),
                            _buildParameterCard(
                                'Sunrise/Sunset',
                                '${DateFormat.Hm().format(DateTime.parse(weather.sunrise))} / ${DateFormat.Hm().format(DateTime.parse(weather.sunset))}',
                                Icons.wb_sunny),
                          ],
                        ),
                      ),
                      AnimatedSize(
                        duration: const Duration(milliseconds: 300),
                        child: selectedParameter == 'Sunrise/Sunset' &&
                                !showGraph
                            ? Card(
                                shadowColor: Colors.grey ,
                                elevation: 5,
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                child: SunriseSunsetWidget(
                                  sunrise: weather.sunrise,
                                  sunset: weather.sunset,
                                ))
                            : showGraph
                                ? Card(
                                    key: ValueKey<String>(selectedParameter),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8),
                                    child: Container(
                                      height:
                                          300, // Adjusted height for the chart
                                      padding: const EdgeInsets.all(8.0),
                                      child: WeatherChart(
                                        data: snapshot.data!,
                                        parameter: selectedParameter,
                                      ),
                                    ),
                                  )
                                : Container(), // Empty container when no graph is shown
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

  Widget _buildParameterCard(String parameter, dynamic value, IconData icon) {
    bool isSelected = parameter == selectedParameter;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedParameter = parameter;
          showGraph = parameter != 'Sunrise/Sunset';
        });
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
          side: isSelected
              ? const BorderSide(color: Colors.blue, width: 2)
              : BorderSide.none,
        ),
        color: Colors.white,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment
                .spaceBetween, // Aligns the text to left and right
            children: [
              Row(
                children: [
                  Icon(icon, size: 24.0),
                  const SizedBox(width: 8.0),
                  Text(
                    value.toString(),
                    style: const TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
              Text(
                parameter,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
