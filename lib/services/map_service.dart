import 'dart:convert';
import 'package:fishingapp/models/location_model.dart';
import 'package:fishingapp/models/spot_model.dart';
import 'package:fishingapp/services/api_contant.dart';
import 'package:fishingapp/services/auth_service.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapService {
  Future<Set<Marker>> getMarkers() async {
    final accessToken = await AuthService().getAccessToken();
    final userId = await AuthService().getUserId();
    print(accessToken);
    final response = await http.get(
      Uri.parse('$BASE_URL/users/$userId/spots'),
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      final List spots = json.decode(response.body);
      return spots.map((spot) {
        return Marker(
          markerId: MarkerId(spot['id'].toString()),
          position:
              LatLng(double.parse(spot['lat']), double.parse(spot['lng'])),
          infoWindow: InfoWindow(
            title: spot['name'],
            snippet: spot['description'],
          ),
        );
      }).toSet();
    } else {
      print(response.statusCode);
      throw Exception('Failed to load spots');
    }
  }

  Future<List<Catch>> getSpots() async {
    final accessToken = await AuthService().getAccessToken();
    final userId = await AuthService().getUserId();
    print(accessToken);
    final response = await http.get(
      Uri.parse('$BASE_URL/users/$userId/spots'),
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      final List spots = json.decode(response.body);
      return spots.map((spot) => Catch.fromJson(spot)).toList();
    } else {
      print(response.statusCode);
      throw Exception('Failed to load spots');
    }
  }

  Future<List<Catch>> getAllSpots() async {
    final accessToken = await AuthService().getAccessToken();
    final response = await http.get(
      Uri.parse('$BASE_URL/spots?all=true'),
      headers: {'Authorization': 'Bearer $accessToken'},
    );
    if(response.statusCode == 200 || response.statusCode == 201) {
      final List spots = json.decode(response.body);
      return spots.map((spot) => Catch.fromJson(spot)).toList();
    } else {
      print("Failed to load spots ${response.statusCode} ${response.body}");
      throw Exception('Failed to load spots');
    }
  }

  Future <Location> getFavoriteLocation() async {
    final accessToken = await AuthService().getAccessToken();
    final response = await http.get(
      Uri.parse('$BASE_URL/locations/favorite'),
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      final location = json.decode(response.body);
      return Location.fromMap(location);
    } else {

      throw Exception('Failed to load favorite location');
    } 
  }

}
