class Location {
  final int id;
  final double latitude;
  final double longitude;
  final String name;
  final String description;
  final String? pictureUrl;
   bool isFavorite;

  Location({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.name,
    required this.description,
    this.pictureUrl,
    required this.isFavorite,
  });

  factory Location.fromMap(Map<String, dynamic> map) {
    try {
      return Location(
        id: map['id'] as int,
        latitude: double.parse(map['latitude'].toString()),
        longitude: double.parse(map['longitude'].toString()),
        name: map['name'] as String,
        description: map['description'] as String,
        pictureUrl: map['picture_url'] as String?,
        isFavorite: map['is_favorite'] == 1 ? true : false,
      );
    } catch (e) {
      throw Exception('Error parsing location: $e');
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'latitude': latitude,
      'longitude': longitude,
      'name': name,
      'description': description,
      'picture_url': pictureUrl,
      'is_favorite': isFavorite ? 1 : 0,
    };
  }

  
}
