import 'dart:convert';
import 'package:fishingapp/models/user_model.dart';
import 'package:fishingapp/services/api_contant.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';
class AuthService {
  Future<User?> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$BASE_URL/login'),
      body: {'username': username, 'password': password},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final String accessToken = responseData['access_token'];

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('access_token', accessToken);
      await prefs.setInt('user_id', responseData['user_id']);

      return getUserData();
    } else {
      return null;
    }
  }

  Future<void> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('access_token');
  }

  Future<String?> getAccessToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  Future<int?> getUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt("user_id");
  }

  Future<bool> isLoggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token') != null;
  }

  Future<User> getUserData() async {
    final String? accessToken = await getAccessToken();

    if (accessToken != null) {
      final user_id = await getUserId();
      final response = await http.get(
        Uri.parse('$BASE_URL/users/$user_id'),
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        return User.fromJson(responseData);
      } else {
        throw Exception('Failed to load user data');
      }
    } else {
      throw Exception('No access token found');
    }
  }

  Future<User> register(String username, String email, String password) async {
    final response = await http.post(
      Uri.parse('$BASE_URL/register'),
      body: {'username': username, 'email': email, 'password': password},
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final String accessToken = responseData['access_token'];

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('access_token', accessToken);
      await prefs.setInt('user_id', responseData['user_id']);

      return getUserData();
    } else {
      throw Exception('Failed to register user');
    }
  }


  final GoogleSignIn _googleSignIn = GoogleSignIn();
  Future<GoogleSignInAccount?> googleSignIn() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;

    // final response = await http.post(
    //   Uri.parse('$BASE_URL/google-login'),
    //   body: {'id_token': googleAuth.idToken},
    // );

    // if (response.statusCode == 200 || response.statusCode == 201) {
    //   final Map<String, dynamic> responseData = json.decode(response.body);
    //   final String accessToken = responseData['access_token'];

    //   final SharedPreferences prefs = await SharedPreferences.getInstance();
    //   await prefs.setString('access_token', accessToken);
    //   await prefs.setInt('user_id', responseData['user_id']);

    //   return getUserData();
    // } else {
    //   throw Exception('Failed to login with Google');
    // }
  }
}
