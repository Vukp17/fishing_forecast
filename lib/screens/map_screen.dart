import 'package:fishingapp/services/api_contant.dart';
import 'package:fishingapp/services/auth_service.dart';
import 'package:fishingapp/services/map_service.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Set<Marker> _markers = {};
  bool _showImage = false;
  
  void _onMapCreated(GoogleMapController controller) async {
    final spots = await MapService().getSpots();
    setState(() {
      _markers.addAll(spots.map((spot) {
        return Marker(
          markerId: MarkerId(spot['id'].toString()),
          position:
              LatLng(double.parse(spot['lat']), double.parse(spot['lng'])),
          infoWindow: InfoWindow(
            title: spot['name'],
            snippet: 'Description: ${spot['description']}',
          ),
            onTap: () async {
            final accessToken = await AuthService().getAccessToken();
            if (!spot['image_id'].startsWith('http') && !spot['image_id'].startsWith('https')) {
              final response = await http.get(
              Uri.parse('$BASE_URL/images/${spot['image_id']}'),
              headers: {'Authorization': 'Bearer $accessToken'},
              );
              print(accessToken);
              if (response.statusCode == 200) {
              showDialog(
                context: context,
                builder: (context) {
                return AlertDialog(
                  title: Text('Description: ${spot['description']}'),
                  content: Image.memory(response.bodyBytes),
                  actions: <Widget>[
                  TextButton(
                    child: Text('OK'),
                    onPressed: () {
                    Navigator.of(context).pop();
                    },
                  ),
                  ],
                );
                },
              );
              } else {
              print('Failed to load image: ${response.statusCode} , ${response.body}');
              }
            } else {
              showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                title: Text('Description: ${spot['description']}'),
                content: Image.network(spot['image_id']),
                actions: <Widget>[
                  TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  ),
                ],
                );
              },
              );
            }
            },
        );
      }).toSet());
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
