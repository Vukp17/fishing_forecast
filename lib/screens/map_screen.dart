import 'package:fishingapp/models/location_model.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import '../models/spot_model.dart';
import '../services/api_contant.dart';
import '../services/auth_service.dart';
import '../services/map_service.dart';
import '../widgets/dialogs/spot_preview_dialog.dart';
import '../widgets/panels/spot_preview_panel.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class MapScreen extends StatefulWidget {
  final Location? initialLocation;

  const MapScreen({Key? key, this.initialLocation}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Set<Marker> _markers = {};
  bool _showImage = false;
  bool _showMySpots = true; // New state variable
  LatLng? favoriteLocation;

  @override
  void initState() {
    super.initState();
    if (widget.initialLocation != null) {
      favoriteLocation =
          LatLng(widget.initialLocation!.latitude, widget.initialLocation!.longitude);
    }else{
      favoriteLocation = LatLng(46.5547, 15.6459);
    }
    _getAllSpots();
  }

  Future<void> _getAllSpots() async {
    final spots = await MapService().getAllSpots();
    _addMarkers(spots);
  }

  Future<void> _getUserSpots() async {
    final spots = await MapService().getSpots();
    _addMarkers(spots);
  }

  void _addMarkers(List<Catch> spots) {
    setState(() {
      _markers.clear(); // Clear previous markers
      _markers.addAll(spots.map((spot) {
        return Marker(
          markerId: MarkerId(spot.id.toString()),
          position: LatLng(double.parse(spot.lat), double.parse(spot.lng)),
          infoWindow: InfoWindow(title: spot.name),
          onTap: () => _onMarkerTapped(spot),
        );
      }).toSet());
    });
  }

  Future<void> _onMarkerTapped(Catch spot) async {
    final accessToken = await AuthService().getAccessToken();
    if (!spot.imageId.startsWith('http') && !spot.imageId.startsWith('https')) {
      final response = await http.get(
        Uri.parse('$BASE_URL/images/${spot.imageId}'),
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        _showImageDialog(
          spot.user!.username,
          Image.memory(response.bodyBytes),
          spot.name,
        );
      } else {
        print('Failed to load image: ${response.statusCode}, ${response.body}');
      }
    } else {
      _showImageDialog(
        spot.user!.username,
        Image.network(spot.imageId),
        spot.name,
      );
    }
  }

  void _showImageDialog(String username, Widget image, String location) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return SpotPreviewPanel(
          username: username,
          image: image,
          location: location,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text( AppLocalizations.of(context)!.map)
      ),
      body: Stack(
        children: [
          if (favoriteLocation != null)
            GoogleMap(
              onMapCreated: (controller) {
                // Move camera to favorite location when map is ready
                controller.animateCamera(CameraUpdate.newLatLngZoom(favoriteLocation!, 14.0));
              },
              markers: _markers,
              initialCameraPosition: CameraPosition(
                target: favoriteLocation!,
                zoom: 14.0,
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
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text (AppLocalizations.of(context)!.my_spots)
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(AppLocalizations.of(context)!.all_spots)
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