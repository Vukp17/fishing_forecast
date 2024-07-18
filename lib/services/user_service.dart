import 'dart:convert';

import 'package:fishingapp/models/user_model.dart';
import 'package:fishingapp/services/api_contant.dart';
import 'package:fishingapp/services/auth_service.dart';
import 'package:http/http.dart' as http;

class UserService {

  Future<void> updateUser(
      User user, String username, String email, String languageCode) async {
    // Fetch the access token dynamically
    final String? accessToken = await AuthService().getAccessToken();

    final response = await http.put(
      Uri.parse('$BASE_URL/users/${user.id}'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'language_id': languageCode,
        'username': username,
        'email': email, // Include other fields if necessary
      }),
    );


    if (response.statusCode == 200) {
      print('User updated , ${response.body}');
      Map<String, dynamic> responseData = jsonDecode(response.body);
      User updatedUser = User.fromJson(responseData['user']);
      UserModel().setUser(updatedUser);
    } else {
      print('Failed to update user: ${response.statusCode}, ${response.body}');
      throw Exception('Failed to update user');
    }
  }
}
