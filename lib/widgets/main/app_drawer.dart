import 'package:fishingapp/models/user_model.dart';
import 'package:flag/flag.dart';
import 'package:flag/flag_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fishingapp/providers/language_provider.dart';

import 'package:flutter_localizations/flutter_localizations.dart';


class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Consumer<UserModel>(
            builder: (context, userModel, child) {
              return UserAccountsDrawerHeader(
                accountName: Text(userModel.user?.username ?? 'Guest'),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF4a7484),
                      Color(0xFF40d3c3),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ), // Set the color here
                ),
                accountEmail: Text(userModel.user?.email ?? 'guest@example.com'),
                currentAccountPicture: const CircleAvatar(
                  child: FlutterLogo(size: 42.0),
                ),
              );
            },
          ),
          ExpansionTile(
            leading: const Icon(Icons.language),
            title: const Text('Languages'),
            children: <Widget>[
              ListTile(
                leading: Flag.fromCode(FlagsCode.US, height: 20, width: 30),
                title: const Text('English'),
                onTap: () {
                  Locale newLocale = const Locale('en', 'US');
                  Provider.of<LanguageProvider>(context, listen: false).changeLocale(newLocale);

                },
              ),
              ListTile(
                // leading: Flag.fromCode(Fla, height: 20, width: 30),
                title: const Text('Serbian'),
                onTap: () {
                  Locale newLocale = const Locale('sr', 'RS');
                  Provider.of<LanguageProvider>(context, listen: false).changeLocale(newLocale);
                  // Update the locale of your app to Spanish here
                },
              ),
              ListTile(
                // leading: Flag.fromCode(FlagsCode.SO, height: 20, width: 30),
                title: const Text('Slovianian'),
                onTap: () {
                  Locale newLocale = const Locale('sl', 'SI');
                  // Update the locale of your app to Spanish here
                },
              ),
              ListTile(
                // leading: Flag.fromCode(FlagsCode.HR, height: 20, width: 30),
                title: const Text('Croatian'),
                onTap: () {
                  Locale newLocale = const Locale('cr', 'HR');
                  // Update the locale of your app to Spanish here
                },
              ),
              
              // Add more languages here
            ],
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('History of Catches'),
            onTap: () {
              // Update the state of the app
              // Then close the drawer
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}