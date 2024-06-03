import 'package:fishingapp/models/spot_model.dart';
import 'package:fishingapp/services/api_contant.dart';
import 'package:fishingapp/services/auth_service.dart';
import 'package:fishingapp/services/map_service.dart';
import 'package:fishingapp/widgets/dialogs/spot_preview_dialog.dart';
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
  bool _showMySpots = true; // New state variable

  @override
  void initState() {
    super.initState();
    _getAllSpots();
  }

  Future<void> _getAllSpots() async {
    final spots = await _fetchAllSpots();
    _addMarkers(spots);
  }

  Future<void> _getUserSpots() async {
    final spots = await _fetchUserSpots();
    _addMarkers(spots);
  }

  Future<List<Catch>> _fetchAllSpots() async {
    return await MapService().getAllSpots();
  }

  Future<List<Catch>> _fetchUserSpots() async {
    // Add your logic here to fetch only the user's spots
    return await MapService().getSpots();
  }
void _showImageDialog(String username, Widget image, String location) {
  showDialog(
    context: context,
    builder: (context) {
      return SpotPreviewDialog(username: username, image: image, location: location);
    },
  );
}
void _addMarkers(List<Catch> spots) {
    setState(() {
      _markers.clear(); // Clear previous markers
      _markers.addAll(spots.map((spot) {
        return Marker(
          markerId: MarkerId(spot.id.toString()),
          position:
              LatLng(double.parse(spot.lat), double.parse(spot.lng)),
          infoWindow: InfoWindow(
            title: spot.name),
          onTap: () => _onMarkerTapped(spot),
        );
      }).toSet());
    });
  }

  Future<void> _onMarkerTapped(Catch spot) async {
    final accessToken = await AuthService().getAccessToken();
    if (!spot.imageId.startsWith('http') &&
        !spot.imageId.startsWith('https')) {
      final response = await http.get(
        Uri.parse('$BASE_URL/images/${spot.imageId}'),
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        _showImageDialog(spot.user!.username, Image.memory(response.bodyBytes),spot.name);
      } else {
        print(
            'Failed to load image: ${response.statusCode} , ${response.body}');
      }
    } else {
      _showImageDialog(spot.user!.username, Image.network(spot.imageId), spot.name);
    }
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
            onMapCreated:
                (controller) {}, // Empty function as loading happens in initState
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
          Positioned(
            top: 20,
            left: MediaQuery.of(context).size.width / 2 - 100,
            child: Container(
              width: 215.3,
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                  ),
                ],
              ),
              child: ToggleButtons(
                borderRadius: BorderRadius.circular(30),
                borderWidth: 2,
                selectedBorderColor: Theme.of(context).primaryColor,
                selectedColor: Theme.of(context).primaryColor,
                fillColor: Theme.of(context).primaryColor.withOpacity(0.1),
                isSelected: [_showMySpots, !_showMySpots],
                onPressed: (int index) {
                  setState(() {
                    _showMySpots = index == 0;
                    if (_showMySpots) {
                      _getUserSpots();
                    } else {
                      _getAllSpots();
                    }
                  });
                },
                children: const [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text('My Spots'),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text('All Spots'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
