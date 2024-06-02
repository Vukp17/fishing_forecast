import 'dart:typed_data';
import 'package:http/http.dart' as http;

import 'package:fishingapp/services/api_contant.dart';
import 'package:fishingapp/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:fishingapp/models/spot_model.dart';

class FeedCard extends StatelessWidget {
  final Catch catchItem;

  /// FeedCard constructor
  /// @param catchItem
  /// @returns FeedCard
  FeedCard({required this.catchItem});
  Future<Uint8List?> _loadImage() async {
    if (!catchItem.imageId.startsWith('http') &&
        !catchItem.imageId.startsWith('https')) {
      final accessToken = await AuthService().getAccessToken();
      final response = await http.get(
        Uri.parse('$BASE_URL/images/${catchItem.imageId}'),
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        throw Exception(
            'Failed to load image: ${response.statusCode} , ${response.body}');
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List?>(
      future: catchItem.imageId.startsWith('http') ||
              catchItem.imageId.startsWith('https')
          ? null
          : _loadImage(),
      builder: (BuildContext context, AsyncSnapshot<Uint8List?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return Card(
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text(catchItem.user?.username ?? 'Unknown User'),
                ),
                Stack(
                  children: [
                    if (snapshot.data != null)
                      Image.memory(
                        snapshot.data!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 200,
                        errorBuilder: (context, error, stackTrace) =>
                            const Text('Image not found'),
                      )
                    else
                      Image.network(
                        catchItem.imageId,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 200,
                        errorBuilder: (context, error, stackTrace) =>
                            const Text('Image not found'),
                      ),
                    // if (snapshot.data == null &&
                    //     !catchItem.imageId.startsWith('http'))
                    //   Center(
                    //     child: CircularProgressIndicator(),
                    //   ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        catchItem.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        catchItem.description.length > 50
                            ? '${catchItem.description.substring(0, 50)}... (more)'
                            : catchItem.description,
                      ),
                      const SizedBox(height: 10),
                      if (catchItem.description.length > 50)
                        TextButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Description'),
                                content: Text(catchItem.description),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Close'),
                                  ),
                                ],
                              ),
                            );
                          },
                          child: const Text('Read more'),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
