import 'dart:io';

import 'package:fishingapp/screens/feed_screen.dart';
import 'package:fishingapp/screens/home_screen.dart';
import 'package:fishingapp/screens/log_catch.dart';
import 'package:fishingapp/screens/map_screen.dart';
import 'package:fishingapp/screens/weather_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class BottomNavigationExample extends StatefulWidget {
  @override
  _BottomNavigationExampleState createState() =>
      _BottomNavigationExampleState();
}

class _BottomNavigationExampleState extends State<BottomNavigationExample> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    MapScreen(),
    FeedScreen(),
    WeatherScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final picker = ImagePicker();
          final pickedFile = await picker.pickImage(source: ImageSource.gallery);

          if (pickedFile != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LogCatchScreen(imageFile: File(pickedFile.path)),
              ),
            );
          } else {
            // ignore: avoid_print
            print('No image selected.');
          }
        },
        backgroundColor: const Color(0xFF40d3c3),
        child: const Icon(Icons.add),
        
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Material(
            elevation: 5.0, // This adds a shadow
            child: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.map),
                  label: 'Map',
                  backgroundColor: Colors.white
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.feed),
                  label: 'Feed',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.sunny),
                  label: 'Weather',
                )
              ],
              backgroundColor: Colors.white,
              elevation: 0, // Remove the elevation from the BottomNavigationBar itself
              selectedItemColor:  const Color(0xFF40d3c3),
              unselectedItemColor: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}