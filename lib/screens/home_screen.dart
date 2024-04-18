import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
//widgets
import '/widgets/home/fishing_spot.dart';
import '/widgets/home/temperature_card.dart';

//services
import '/services/weather_service.dart';
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<double> _hourlyWeather = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchHourlyWeather();
  }

  Future<void> _fetchHourlyWeather() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Call the fetchHourlyWeather method from WeatherService
      _hourlyWeather = await WeatherService.fetchHourlyWeather();
    } catch (error) {
      setState(() {
        _hourlyWeather = [0.0]; // Default value
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fishing Spots'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TemperatureCard(
                    temperature: _hourlyWeather.isNotEmpty ? _hourlyWeather[0] : 0.0,
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: 5, // Let's create 5 dummy fishing spots for now
                    itemBuilder: (context, index) {
                      // Dummy data for fishing spots
                      final fishingSpots = [
                        'Lake ABC',
                        'River XYZ',
                        'Pond 123',
                        'Ocean 789',
                        'Stream LMN',
                      ];

                      return ListTile(
                        title: Text(fishingSpots[
                            index]), // Display the fishing spot name
                        subtitle: Text(
                            'Description of the fishing spot goes here'), // Add description here
                        leading: Icon(Icons
                            .location_on), // Use a location icon as leading widget
                        onTap: () {
                          // Add navigation to the fishing spot details screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FishingSpotDetailsScreen(
                                  fishingSpotName: fishingSpots[index]),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}



