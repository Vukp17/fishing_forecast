import 'package:fishingapp/models/spot_model.dart';
import 'package:fishingapp/services/api_contant.dart';
import 'package:fishingapp/services/auth_service.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:convert';
import 'dart:io';

class SpotService {
  Future<void> saveSpot(String title, DateTime date, String lng, String lat,
      String description, File imageFile) async {
    try {
      final accessToken = await AuthService().getAccessToken();
      final userId = await AuthService().getUserId();
      String baseUrl = '$BASE_URL/users/$userId/spots';

      var request = http.MultipartRequest('POST', Uri.parse(baseUrl));

      request.headers.addAll(<String, String>{
        'Content-Type': 'multipart/form-data',
        'Authorization': 'Bearer $accessToken',
      });

      request.fields['title'] = title;
      request.fields['date'] = date.toString();
      request.fields['lat'] = lat;
      request.fields['lng'] = lng;
      request.fields['description'] = description;

      request.files.add(await http.MultipartFile.fromPath(
        'image',
        imageFile.path,
        contentType: MediaType('image', 'jpeg'),
      ));
      print('Sending request...');
      var response = await request.send();

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Spot saved successfully');
      } else {
        throw Exception(
            'Failed to save spot, status code: ${response.statusCode}, ${await response.stream.bytesToString()}');
      }
    } catch (e) {
      print('Error: $e');
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
      final List<dynamic> spots = json.decode(response.body);
      List<Catch> catchList =
          spots.map((spot) => Catch.fromJson(spot)).toList();
      return catchList;
    } else {
      print(response.statusCode);
      throw Exception('Failed to load spots');
    }
  }

  Future<List<Catch>> getAllSpots({int page = 1}) async {
    final accessToken = await AuthService().getAccessToken();
    print('Access token: $accessToken');
    final response = await http.get(
      Uri.parse('$BASE_URL/spots?page=$page'),
      headers: {'Authorization': 'Bearer $accessToken'},
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final List<dynamic> spots = responseData['data'];
      print(spots[0]);
      List<Catch> catchList =
          spots.map((spot) => Catch.fromJson(spot)).toList();
      return catchList;
    } else {
      print(response.statusCode);
      throw Exception('Failed to load spots');
    }
  }

  Future<List<Catch>> getMoreSpots(int page) async {
    final accessToken = await AuthService().getAccessToken();
    final response = await http.get(
      Uri.parse('$BASE_URL/spots?page=$page'),
      headers: {'Authorization': 'Bearer $accessToken'},
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final List<dynamic> spots = responseData['data'];
      List<Catch> catchList =
          spots.map((spot) => Catch.fromJson(spot)).toList();
      return catchList;
    } else {
      print(response.statusCode);
      throw Exception('Failed to load spots');
    }
  }
}
