
import 'package:fishingapp/models/user_model.dart';
import 'package:fishingapp/services/auth_service.dart';
import 'package:fishingapp/widgets/main/app_drawer.dart';
import 'package:flutter/material.dart';

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
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: AppDrawer(),

      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TemperatureCard(
                    temperature:
                        _hourlyWeather.isNotEmpty ? _hourlyWeather[0] : 0.0,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Locations',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  height: 60.0,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      buildFilterPill('Favorites'),
                      buildFilterPill('Recent'),
                      buildFilterPill('All'),
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

  Widget buildFilterPill(String title) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ChoiceChip(
        label: Text(title),
        selected: _selectedFilter == title,
        selectedColor: Color(0xFF40d3c3),
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