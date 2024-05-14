import 'dart:io';

import 'package:fishingapp/screens/home_screen.dart';
import 'package:fishingapp/screens/log_catch.dart';
import 'package:fishingapp/screens/map_screen.dart';
import 'package:fishingapp/screens/profile_screen.dart';
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
    ProfileScreen(),
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
            print('No image selected.');
          }
        },
        child: Icon(Icons.add),
        backgroundColor: Color(0xFF40d3c3),
        
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            items: [
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
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
            backgroundColor: Colors.white,
            elevation: 5,
            selectedItemColor:  Color(0xFF40d3c3),// Set the color here
            unselectedItemColor: Colors.grey, // Set the color for unselected items here


          ),
        ),
      ),
    );
  }
}