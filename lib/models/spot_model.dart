import 'package:fishingapp/models/user_model.dart';

class Catch {
  final String imageId;
  final String description;
  final String name;
  final DateTime created_at;
  final DateTime updated_at;
  final String lat;
  final String lng;
  final int user_id;
  final User? user;

  Catch({
    required this.imageId,
    required this.description,
    required this.name,
    required this.created_at,
    required this.updated_at,
    required this.lat,
    required this.lng,
    required this.user_id,
    this.user,
  });

  factory Catch.fromJson(Map<String, dynamic> json) {
    return Catch(
      imageId: json['image_id'],
      description: json['description'],
      name: json['name'],
      created_at: DateTime.parse(json['created_at']),
      updated_at: DateTime.parse(json['updated_at']),
      lat: json['lat'],
      lng: json['lng'],
      user_id: json['user_id'],
      user: json['user'] != null ? User.fromJson(json['user']) : null,
    );
  }
}
