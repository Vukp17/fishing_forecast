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
    weatherData = Provider.of<WeatherService>(context, listen: false).fetchWeatherData('46.5547', '15.6459', selectedDate);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fishing Weather Forecast'),
      ),
      body: Column(
        children: [
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
              IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: () => _selectDate(context),
              ),
            ],
          ),
          Text("Selected Date: ${DateFormat('yyyy-MM-dd').format(selectedDate)}"),
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
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0), // Set the border radius as you need
                    ),
                    child: Container(
                      height: 100, // Set the height as you need
                      child: WeatherChart(
                        data: snapshot.data!,
                        parameter: selectedParameter,
                      ),
                    ),
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
