
import 'package:flutter/foundation.dart';

class User {
  final int id;
  final String username;
  final String email;
  final String? language_id;

  User({
    required this.id,
    required this.username,
    required this.email,
    this.language_id,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      language_id: json['language_id'],
    );
  }
}



class UserModel extends ChangeNotifier {
  User? _user;

  User? get user => _user;

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }
}