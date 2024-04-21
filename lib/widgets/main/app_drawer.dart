import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text('User Name'),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF4a7484),
                  Color(0xFF40d3c3),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ), // Set the color here
            ),
            accountEmail: Text('user@example.com'),
            currentAccountPicture: CircleAvatar(
              child: FlutterLogo(size: 42.0),
            ),
          ),
          ListTile(
            leading: Icon(Icons.language),
            title: Text('Languages'),
            onTap: () {
              // Update the state of the app
              // Then close the drawer
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.history),
            title: Text('History of Catches'),
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
