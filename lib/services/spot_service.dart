import 'package:fishingapp/services/api_contant.dart';
import 'package:fishingapp/services/auth_service.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:convert';
import 'dart:io';

class SpotService {
  Future<void> saveSpot(String title, DateTime date, String location, String description, File imageFile) async {
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
    request.fields['location'] = location;
    request.fields['description'] = description;

    request.files.add(await http.MultipartFile.fromPath(
      'image',
      imageFile.path,
      contentType: MediaType('image', 'jpeg'),
    ));

    var response = await request.send();

    if (response.statusCode == 200) {
      print('Spot saved successfully');
    } else {
      throw Exception('Failed to save spot');
    }
  }
}