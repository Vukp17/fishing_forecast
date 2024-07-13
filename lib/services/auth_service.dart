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
    final response = await http.post(
      Uri.parse('$BASE_URL/logout'),
      headers: {'Authorization': 'Bearer ${prefs.getString('access_token')}'},
    );

    if (response.statusCode == 200) {
      prefs.remove('access_token');
      prefs.remove('user_id');
      prefs.remove('token');
      logoutGoogle();

    } else {
      throw Exception('Failed to logout user');
    }
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
    print('Test');
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

  final GoogleSignIn _googleSignIn = GoogleSignIn( 
    
    scopes: [
      'email',
      'profile',
      'openid',

    ],
  );
  Future<User?> googleSignIn() async {
    try {
      await _googleSignIn
          .signOut(); // Ensure the user is signed out before attempting to sign in again
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw Exception('Google Sign-In was aborted');
      }

      final GoogleSignInAuthentication googleAuth =await googleUser.authentication;

      final response = await http.post(
        Uri.parse('$BASE_URL/google-login'),
        body: {'username': googleUser.displayName,'email': googleUser.email},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final String accessToken = responseData['access_token'];

        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('access_token', accessToken);
        await prefs.setInt('user_id', responseData['user_id']);
        saveToken(accessToken);
        return getUserData();
      } else {
        throw Exception('Failed to login with Google ${response.statusCode}, response: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

    Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', token);
  }

  Future<String?> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  Future<void> deleteToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
  }

  logoutGoogle() async {
    await _googleSignIn.signOut();
  }
  

}
