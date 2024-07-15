import 'package:fishingapp/screens/mappicker_screen.dart';
import 'package:fishingapp/widgets/weather/sunrise_widget.dart';
import 'package:fishingapp/widgets/weather/weather_widet.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../services/weather_service.dart';
import '../services/locations_service.dart';
import '../models/weather_model.dart';
import '../models/location_model.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late Future<List<WeatherData>> weatherData;
  late Future<List<Location>> locationsData;
  String selectedParameter = 'Temperature';
  DateTime selectedDate = DateTime.now();
  bool showGraph = false;
  Location? selectedLocation;

  @override
  void initState() {
    super.initState();
    locationsData = LocationsService().fetchLocations();
    locationsData.then((locations) {
      setState(() {
        if (locations.isNotEmpty) {
          selectedLocation = locations.first;
          fetchWeather();
        }
      });
    });
  }

  void fetchWeather() {
    if (selectedLocation != null) {
      weatherData = Provider.of<WeatherService>(context, listen: false)
          .fetchWeatherData(selectedLocation!.latitude.toString(),
              selectedLocation!.longitude.toString(), selectedDate);
    }
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

  Future<void> _selectLocationFromMap(BuildContext context) async {
    final LatLng? pickedLocation = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MapPickerScreen()),
    );
    if (pickedLocation != null) {
      setState(() {
        selectedLocation = Location(
          id: 3,
          name: 'Custom Location',
          description: 'Location selected from map',
          latitude: pickedLocation.latitude,
          longitude: pickedLocation.longitude,
          isFavorite: false,
        );
        fetchWeather();
      });
    }
  }

  List<DateTime> _generateWeekDates(DateTime selectedDate) {
    return List.generate(7, (index) => selectedDate.add(Duration(days: index)));
  }

  bool isTemperatureGood(double temperature) {
    return temperature >= 10 && temperature <= 30;
  }

  bool isWindSpeedGood(double windSpeed) {
    return windSpeed < 15;
  }

  bool isHumidityGood(double humidity) {
    return humidity >= 30 && humidity <= 70;
  }

  @override
  Widget build(BuildContext context) {
    List<DateTime> weekDates = _generateWeekDates(selectedDate);
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.forecast),
      ),
      body: FutureBuilder<List<Location>>(
        future: locationsData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Failed to load locations.'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No locations available.'));
          } else {
            return Column(
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
                          child: Column(
                            children: [
                              Icon(Icons.calendar_today, color: Colors.grey),
                              Text(AppLocalizations.of(context)!.calendar,
                                  style: TextStyle(color: Colors.grey)),
                            ],
                          ),
                        ),
                      ),
                    ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: DropdownButton<Location>(
                          isExpanded: true,
                          value: snapshot.data!.contains(selectedLocation)
                              ? selectedLocation
                              : null,
                          onChanged: (Location? newValue) {
                            setState(() {
                              selectedLocation = newValue!;
                              fetchWeather();
                            });
                          },
                          items: snapshot.data!.map<DropdownMenuItem<Location>>(
                              (Location location) {
                            return DropdownMenuItem<Location>(
                              value: location,
                              child: Text(location.name),
                            );
                          }).toList(),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.map),
                        onPressed: () => _selectLocationFromMap(context),
                      ),
                    ],
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
                        return Center(child: Text('No weather data available.'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                            child: Text('No weather data available.'));
                      } else {
                        final weather = snapshot.data!
                            .where((data) => data.date.day == selectedDate.day)
                            .toList();
                        return ListView(
                          children: [
                            _buildParameterCard(
                                AppLocalizations.of(context)!.temperature,
                                weather.first.temperature,
                                Icons.thermostat,
                                isTemperatureGood(weather.first.temperature)),
                            _buildParameterCard(
                                AppLocalizations.of(context)!.wind_speed,
                                weather.first.windSpeed,
                                Icons.air,
                                isWindSpeedGood(weather.first.windSpeed)),
                            _buildParameterCard(
                                AppLocalizations.of(context)!.sunrise,
                                '${DateFormat.Hm().format(DateTime.parse(weather.first.sunrise))} / ${DateFormat.Hm().format(DateTime.parse(weather.first.sunset))}',
                                Icons.wb_sunny,
                                true),
                            _buildParameterCard(
                                AppLocalizations.of(context)!.humidity,
                                weather.first.relative_humidity,
                                Icons.water,
                                isHumidityGood(weather.first.relative_humidity)),
                          ],
                        );
                      }
                    },
                  ),
                ),
                AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  child: showGraph
                      ? Card(
                          key: ValueKey<String>(selectedParameter),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: Container(
                            height: 300, // Adjusted height for the chart
                            padding: const EdgeInsets.all(8.0),
                            child: FutureBuilder<List<WeatherData>>(
                              future: weatherData,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const Center(child: CircularProgressIndicator());
                                } else if (snapshot.hasError) {
                                  print(snapshot.error);
                                  return Center(child: Text('No weather data available.'));
                                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                  return const Center(child: Text('No weather data available.'));
                                } else {
                                  return WeatherChart(
                                    data: snapshot.data!,
                                    parameter: selectedParameter,
                                  );
                                }
                              },
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
    );
  }

  Widget _buildParameterCard(String parameter, dynamic value, IconData icon,
      bool isGood) {
    bool isSelected = parameter == selectedParameter;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedParameter = parameter;
          showGraph = selectedParameter != 'Sunrise/Sunset' &&
              selectedParameter != 'Izlazak/Zalazak sunca' &&
              selectedParameter != 'Vzhod/Zahod sonca';
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon, size: 24.0),
                  const SizedBox(width: 8.0),
                  Text(
                    value.toString(),
                    style: const TextStyle(fontSize: 16.0),
                  ),
                  const SizedBox(width: 8.0),
                  Icon(
                    isGood ? Icons.arrow_upward : Icons.arrow_downward,
                    color: isGood ? Colors.green : Colors.red,
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
