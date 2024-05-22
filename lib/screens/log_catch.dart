import 'package:fishingapp/screens/select_location_screen.dart';
import 'package:fishingapp/services/spot_service.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:io';
import 'package:intl/intl.dart';
// import 'package:geolocator/geolocator.dart';

class LogCatchScreen extends StatefulWidget {
  final File imageFile;

  LogCatchScreen({required this.imageFile});

  @override
  _LogCatchScreenState createState() => _LogCatchScreenState();
}

class _LogCatchScreenState extends State<LogCatchScreen> {
  DateTime _date = DateTime.now();
  String lat = '';
  String lng = '';
  final _titleController = TextEditingController();
  final _dateController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _date)
      setState(() {
        _date = picked;
      });
  }

  saveSpot() async {
    final title = _titleController.text;
    final date = _dateController.text;
    final description = _descriptionController.text;
    // final location = _locationController.text;

    // final position = await Geolocator.getCurrentPosition();
    // final latitude = position.latitude;
    // final longitude = position.longitude;

    print('Title: $title');
    print('Date: $_date');
    print('Description: $description');
    final spot = await SpotService().saveSpot(
      title,
      _date,
      lng,
      lat,
      description,
      widget.imageFile,
    );
    // print('Latitude: $latitude');
    // print('Longitude: $longitude');
  }

  Future<void> _selectLocation() async {
    LatLng selectedLocation = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectLocationScreen(),
      ),
    );

    if (selectedLocation != null) {
      setState(() {
        lat = selectedLocation.latitude.toString();
        lng = selectedLocation.longitude.toString();
      });
    }
  }

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
              Image.file(
                widget.imageFile,
                height: 200, // Set the height of the image
                width: 200, // Set the width of the image
                fit: BoxFit
                    .cover, // Use BoxFit.cover to maintain the aspect ratio of the image
              ),
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                ),
              ),
              TextField(
                controller: _dateController,
                decoration: InputDecoration(
                  labelText: DateFormat.yMMMd().format(_date),
                ),
                onTap: () => _selectDate(context),
              ),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                ),
              ),
              TextField(
                controller: _locationController,
                decoration: InputDecoration(
                  labelText: 'Location: $lat, $lng',
                ),
                onTap: _selectLocation,
              ),
              ElevatedButton(
                onPressed: () {
                  // Save the catch
                  saveSpot();
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
