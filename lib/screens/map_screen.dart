import 'package:fishingapp/services/map_service.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Set<Marker> _markers = {};
  bool _showImage = false;
void _onMapCreated(GoogleMapController controller) async {
  final markers = await MapService().getMarkers();
  setState(() {
    _markers.addAll(markers);
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Maps'),
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            markers: _markers,
            initialCameraPosition: CameraPosition(
              target: LatLng(37.42796133580664, -122.085749655962),
              zoom: 14.4746,
            ),
          ),
          if (_showImage)
            Positioned(
              top: 10,
              left: 10,
              child: Container(
                width: 100,
                height: 100,
                child: Image.network('https://placehold.co/600x400.png'),
              ),
            ),
        ],
      ),
    );
  }
}