import 'package:fishingapp/models/user_model.dart';
import 'package:fishingapp/services/auth_service.dart';
import 'package:fishingapp/widgets/main/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  List<HourlyWeather> _hourlyWeather = [];
  User? _user;
  bool _isLoading = false;
  String _selectedFilter = '';
  @override
  void initState() {
    super.initState();
    _fetchHourlyWeather();
    loadUserData();
  }

  Future<void> loadUserData() async {
    try {
      final userData = await AuthService().getUserData();
      setState(() {
        _user = userData;
      });
    } catch (e) {
      print('Failed to load user data: $e');
    }
  }

  Future<void> _fetchHourlyWeather() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Call the fetchHourlyWeather method from WeatherService
      _hourlyWeather = await WeatherService.fetchHourlyWeather();
      print(_hourlyWeather.length);
    } catch (error) {
      setState(() {
        _hourlyWeather = []; // Default value
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
        title: Text(AppLocalizations.of(context)!.fishingSpots),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
            Container(
            margin: const EdgeInsets.only(right: 16.0),
            decoration: BoxDecoration(
              color: const Color(0xFF42d9c8),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
              IconButton(
                icon: const Icon(Icons.notifications),
                color: Colors.white,
                onPressed: () {
                // Implement your notification logic here
                },
              ),
              Positioned(
                top: 8.0,
                right: 8.0,
                child: Container(
                padding: const EdgeInsets.all(4.0),
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '5', // Replace with the actual number of notifications
                  style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                  ),
                ),
                ),
              ),
              ],
            ),
            ),
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TemperatureCard(
                    hourlyWeatherList:
                        _hourlyWeather.isNotEmpty ? _hourlyWeather : [],
                    currentLocation: 'Maribor',
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    AppLocalizations.of(context)!.locations,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  height: 60.0,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      buildFilterPill(AppLocalizations.of(context)!.favorites),
                      buildFilterPill(AppLocalizations.of(context)!.recent),
                      buildFilterPill(AppLocalizations.of(context)!.all),
                    ],
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
                        subtitle: const Text(
                            'Description of the fishing spot goes here'), // Add description here
                        leading: const Icon(Icons
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

  Widget buildFilterPill(String title) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ChoiceChip(
        label: Text(title),
        selected: _selectedFilter == title,
        selectedColor: const Color(0xFF40d3c3),
        onSelected: (bool selected) {
          setState(() {
            if (selected) {
              _selectedFilter = title;
              // Implement your filtering logic here
            }
          });
        },
      ),
    );
  }
}
