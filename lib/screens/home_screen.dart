import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fishingapp/models/location_model.dart';
import 'package:fishingapp/models/user_model.dart';
import 'package:fishingapp/services/auth_service.dart';
import 'package:fishingapp/services/locations_service.dart';
import 'package:fishingapp/services/weather_service.dart';
import 'package:fishingapp/widgets/main/app_drawer.dart';
import 'package:fishingapp/widgets/home/fishing_spot.dart';
import 'package:fishingapp/widgets/home/temperature_card.dart';

import '/screens/map_screen.dart'; // Import your MapScreen

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<HourlyWeather> _hourlyWeather = [];
  User? _user;
  bool _isLoading = false;
  String _selectedFilter = 'All'; // Default filter set to 'All'
  List<Location> fishingSpots = [];
  List<Location> filteredSpots = [];
  String currentLocationName = 'Maribor';
  Location? _selectedLocation;

  @override
  void initState() {
    super.initState();
    loadUserData();
    _fetchLocations();
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

  Future<void> _fetchLocations() async {
    try {
      fishingSpots = await LocationsService().fetchLocations();
      _applyFilter();
      if (filteredSpots.isNotEmpty) {
        setState(() {
          _selectedLocation = filteredSpots[0];
          currentLocationName = filteredSpots[0].name;
          _fetchHourlyWeather(
              latitude: filteredSpots[0].latitude,
              longitude: filteredSpots[0].longitude,
              locationName: filteredSpots[0].name);
        });
      }
    } catch (e) {
      print('Failed to fetch locations: $e');
    }
  }

  Future<void> _fetchHourlyWeather(
      {double? latitude, double? longitude, String locationName = 'Maribor'}) async {
    setState(() {
      _isLoading = true;
      currentLocationName = locationName;
    });

    try {
      _hourlyWeather =
          await WeatherService.fetchHourlyWeather(latitude: latitude, longitude: longitude);
    } catch (error) {
      setState(() {
        _hourlyWeather = [];
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _toggleFavorite(Location location) async {
    try {
      await LocationsService().updateFavorite(location);
      setState(() {
        location.isFavorite = !location.isFavorite;
      });
      _applyFilter();
    } catch (e) {
      print('Failed to update favorite: $e');
    }
  }

  void _applyFilter() {
    setState(() {
      print('Applying filter: $_selectedFilter');
      if (_selectedFilter == 'Favorites' || _selectedFilter == 'Favoriti' || _selectedFilter == 'Priljubljeno') {
        filteredSpots = fishingSpots.where((spot) => spot.isFavorite).toList();
      } else {
        filteredSpots = fishingSpots;
      }
    });
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
                    hourlyWeatherList: _hourlyWeather.isNotEmpty ? _hourlyWeather : [],
                    currentLocation: currentLocationName,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    AppLocalizations.of(context)!.locations,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  height: 60.0,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      buildFilterPill(AppLocalizations.of(context)!.favorites),
                      buildFilterPill(AppLocalizations.of(context)!.all),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredSpots.length,
                    itemBuilder: (context, index) {
                      final spot = filteredSpots[index];
                      final isSelected = spot == _selectedLocation;
                      return ListTile(
                        title: Text(
                          spot.name,
                          style: TextStyle(
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            color: isSelected ? Colors.blue : Colors.black,
                          ),
                        ),
                        subtitle: Text(spot.description),
                        leading: Icon(
                          spot.isFavorite ? Icons.star : Icons.star_border,
                          color: spot.isFavorite ? Colors.yellow : Colors.grey,
                        ),
                        onTap: () {
                          setState(() {
                            _selectedLocation = spot;
                          });
                          _fetchHourlyWeather(
                              latitude: spot.latitude,
                              longitude: spot.longitude,
                              locationName: spot.name);
                        },
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.favorite,
                                color: spot.isFavorite ? Colors.red : Colors.grey,
                              ),
                              onPressed: () => _toggleFavorite(spot),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.map,
                                color: Colors.blue,
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MapScreen(
                                      initialLocation: spot,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
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
              _applyFilter();
            }
          });
        },
      ),
    );
  }
}
