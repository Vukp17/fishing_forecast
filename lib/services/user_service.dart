import 'dart:convert';

import 'package:fishingapp/models/user_model.dart';
import 'package:fishingapp/services/api_contant.dart';
import 'package:fishingapp/services/auth_service.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

class UserService {
  final accesToken=AuthService().getAccessToken();

  Future<void> updateUser(User user, String username, String email, String languageCode) async {
    final response = await http.put(
      Uri.parse('$BASE_URL/users/${user.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${accesToken}',
      },
      body: jsonEncode(<String, String>{
        'language_id': languageCode,
      }),
    );

    if (response.statusCode != 200 || response.statusCode != 201) {
     print(response.body);
      throw Exception('Failed to update user') ;
    }
  }
}