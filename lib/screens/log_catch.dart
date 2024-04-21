import 'package:flutter/material.dart';
import 'dart:io';

class LogCatchScreen extends StatelessWidget {
  final File imageFile;

  LogCatchScreen({required this.imageFile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Log a Catch'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Image.file(imageFile),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Title',
                ),
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Location',
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // Save the catch
                },
                child: Text('Save Catch'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}