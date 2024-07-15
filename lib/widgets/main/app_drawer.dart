import 'package:fishingapp/models/user_model.dart';
import 'package:fishingapp/screens/history_catches_screen.dart';
import 'package:fishingapp/screens/profile_screen.dart';
import 'package:fishingapp/services/auth_service.dart';
import 'package:flag/flag.dart';
import 'package:flag/flag_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fishingapp/providers/language_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:flutter_localizations/flutter_localizations.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                // User account header and other list tiles go here
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
                      accountEmail:
                          Text(userModel.user?.email ?? 'guest@example.com'),
                      currentAccountPicture: const CircleAvatar(
                        child: Icon(Icons.person),
                        backgroundColor: Colors.white,
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.history),
                  title: Text(AppLocalizations.of(context)!.historyCatches),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HistoryCatchesScreen()),
                    );
                  },
                ),
                Consumer<UserModel>(
                  builder: (context, userModel, child) {
                    return ListTile(
                      leading: const Icon(Icons.settings),
                      title: Text (AppLocalizations.of(context)!.profile),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ProfileScreen(user: userModel.user),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          // Logout ListTile
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: Text(AppLocalizations.of(context)!.logout),
            onTap: () {
              Provider.of<UserModel>(context, listen: false).logout();
              AuthService().logout();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
    );
  }
}
