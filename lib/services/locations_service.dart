import 'dart:convert';
import 'package:fishingapp/models/location_model.dart';
import 'package:fishingapp/services/auth_service.dart';
import 'package:http/http.dart' as http;
import 'package:fishingapp/services/api_contant.dart';

class LocationsService {
  Future<List<Location>> fetchLocations() async {
    final accessToken = await AuthService().getAccessToken();
    const apiUrl = '$BASE_URL/locations';
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      print('Data: $data');
      return data.map((location) => Location.fromMap(location)).toList();
    } else {
      throw Exception('Failed to load locations');
    }
  }

  Future<void> updateFavorite(Location location) async {
    final accessToken = await AuthService().getAccessToken();

    final response =
        await http.put(Uri.parse('$BASE_URL/locations/${location.id}'),
            headers: {
              'Authorization': 'Bearer $accessToken',
              'Content-Type': 'application/json',
            },
            body: jsonEncode(<String, int>{
              'is_favorite': location.isFavorite ? 0 : 1,
            }));

    if (response.statusCode != 200) {
      print('Failed to update location ${response.body}');
      throw Exception('Failed to update location');
    }
  }
}
