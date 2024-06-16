import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SelectLocationScreen extends StatefulWidget {
  @override
  _SelectLocationScreenState createState() => _SelectLocationScreenState();
}

class _SelectLocationScreenState extends State<SelectLocationScreen> {
  LatLng _pickedLocation = const LatLng(37.4219999, -122.0840575);

  void _selectLocation(LatLng position) {
    setState(() {
      _pickedLocation = position;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Location'),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _pickedLocation,
          zoom: 14.4746,
        ),
        onTap: _selectLocation,
        markers: _pickedLocation != null ? {Marker(markerId: const MarkerId('m1'), position: _pickedLocation)} : {},
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.check),
        onPressed: () {
          Navigator.of(context).pop(_pickedLocation);
        },
      ),
    );
  }
}