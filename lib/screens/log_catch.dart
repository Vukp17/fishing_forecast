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
  bool _isLoading = false;
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

  Future<bool> saveSpot() async {
    setState(() {
      _isLoading = true;
    });

    final title = _titleController.text;
    final date = _dateController.text;
    final description = _descriptionController.text;

    try {
      final spot = await SpotService().saveSpot(
        title,
        _date,
        lng,
        lat,
        description,
        widget.imageFile,
      );
      return true;
    } catch (e) {
      print('Error saving spot: $e');
      return false;
    } finally {
      setState(() {
        _isLoading = false;
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
                height: 200,
                width: 200,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: const BorderSide(),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                controller: _dateController,
                decoration: InputDecoration(
                  labelText: DateFormat.yMMMd().format(_date),
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: const BorderSide(),
                  ),
                ),
                onTap: () => _selectDate(context),
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: const BorderSide(),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(
                  labelText: 'Location: $lat, $lng',
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: const BorderSide(),
                  ),
                ),
                onTap: _selectLocation,
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: _isLoading
                    ? null
                    : () async {
                        // Save the catch
                        bool success = await saveSpot();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(success
                                ? 'Catch saved successfully'
                                : 'Error saving catch'),
                            backgroundColor:
                                success ? Colors.green : Colors.red,
                          ),
                        );
                        if (success) {
                          // Navigate back to the map screen and zoom in on the picker
                          Navigator.pop(context);
                          // Add your code here to zoom in on the picker
                        }
                      },
                child: _isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text('Save Catch'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF42d9c8), // Set the button color
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
