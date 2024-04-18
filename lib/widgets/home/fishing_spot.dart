

import 'package:flutter/material.dart';


class FishingSpotDetailsScreen extends StatelessWidget {
  final String fishingSpotName;

  FishingSpotDetailsScreen({required this.fishingSpotName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fishing Spot Details'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Fishing Spot Name: $fishingSpotName',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            // Add more details about the fishing spot here
          ],
        ),
      ),
    );
  }
}
