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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 6.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.home),
              onPressed: () {
                setState(() {
                  _currentIndex = 0;
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.map),
              onPressed: () {
                setState(() {
                  _currentIndex = 1;
                });
              },
            ),
            const SizedBox(width: 48), // The empty space in the middle
            IconButton(
              icon: const Icon(Icons.feed),
              onPressed: () {
                setState(() {
                  _currentIndex = 2;
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.sunny),
              onPressed: () {
                setState(() {
                  _currentIndex = 3;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}