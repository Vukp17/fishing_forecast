import 'package:flutter/material.dart';
import 'package:fishingapp/models/spot_model.dart';

class FeedCard extends StatelessWidget {
  final Catch catchItem;

  FeedCard({required this.catchItem});

  @override
  Widget build(BuildContext context) {
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
          Image.network(
            catchItem.imageId,
            fit: BoxFit.cover,
            width: double.infinity,
            height: 200,
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
}