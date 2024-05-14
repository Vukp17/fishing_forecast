import 'package:fishingapp/models/user_model.dart';
import 'package:fishingapp/providers/language_provider.dart';
import 'package:fishingapp/screens/register_screen.dart';
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

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserModel()),
        ChangeNotifierProvider(create: (context) => LanguageProvider()),
      ],
      child: MyApp(),
    ),
  );
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
      localizationsDelegates: const [
        
        AppLocalizations.delegate, // Add this line
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', 'US'), // English
        Locale('sr', 'RS'), // Serbian
        Locale('sl', 'SI'), // Slovenian
        Locale('cr', 'HR'), // Croatian
      ],
      locale: Provider.of<LanguageProvider>(context).currentLocale,
      home: _authService.isLoggedIn == true
          ? BottomNavigationExample()
          : LoginScreen(),
      routes: {
        '/login': (context) => LoginScreen(),
        '/home': (context) => BottomNavigationExample(),
        '/register': (context) => RegistrationScreen()
      },
    );
  }
}
