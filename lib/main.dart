import 'package:fishingapp/models/user_model.dart';
import 'package:fishingapp/providers/language_provider.dart';
import 'package:fishingapp/screens/register_screen.dart';
import 'package:fishingapp/services/weather_service.dart';
import 'package:fishingapp/widgets/main/bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'screens/home_screen.dart';
// import 'screens/search_screen.dart';
// import 'screens/profile_screen.dart';
//services
import 'package:flutter_localizations/flutter_localizations.dart';
import 'services/auth_service.dart';
import 'screens/login_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final authService = AuthService();
  final token = await authService.loadToken();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserModel()),
        ChangeNotifierProvider(create: (context) => LanguageProvider()),
        Provider(create: (_) => WeatherService()),
      ],
      child: MyApp(isLoggedIn: token != null),
    ),
  );
}

class MyApp extends StatelessWidget {
  final AuthService _authService = AuthService();
  final bool isLoggedIn;

  MyApp({required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeUserData(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        } else if (snapshot.hasError) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(child: Text('Error loading user data')),
            ),
          );
        } else {
          return MaterialApp(
            title: 'Flutter Fishing App',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', 'US'),
              Locale('sr', 'RS'),
              Locale('sl', 'SI'),
              Locale('cr', 'HR'),
            ],
            locale: Provider.of<LanguageProvider>(context).currentLocale,
            home: isLoggedIn ? BottomNavigationExample() : LoginScreen(),
            routes: {
              '/login': (context) => LoginScreen(),
              '/home': (context) => BottomNavigationExample(),
              '/register': (context) => RegistrationScreen()
            },
          );
        }
      },
    );
  }

  Future<void> _initializeUserData(BuildContext context) async {
    final token = await _authService.loadToken();

    if (isLoggedIn && token != null) {
      final userModel = Provider.of<UserModel>(context, listen: false);
      final userData = await _authService.getUserData();
      // Use a post-frame callback to update the user model after the build is complete
      WidgetsBinding.instance.addPostFrameCallback((_) {
        userModel.setUser(userData);
      });
    }
  }
}
