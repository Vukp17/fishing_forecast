import 'package:fishingapp/widgets/main/bottom_navigation.dart';
import 'package:flutter/material.dart';
// import 'screens/home_screen.dart';
// import 'screens/search_screen.dart';
// import 'screens/profile_screen.dart';
//services
import 'services/auth_service.dart';
import 'screens/login_screen.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
    final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Fishing App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity, 
      ),
      home: _authService.isLoggedIn ? BottomNavigationExample() : LoginScreen(),
    );
  }
}

