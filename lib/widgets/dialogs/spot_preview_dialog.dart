
import 'package:flutter/material.dart';

class SpotPreviewDialog extends StatelessWidget {
  final String username;
  final Widget image;
  final String location;

  SpotPreviewDialog({required this.username, required this.image, required this.location});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.person),
          SizedBox(width: 8),
          Text(username),
        ],
      ),
      content: Column(
        children: [
          Text(location, style: TextStyle(fontWeight: FontWeight.bold)),
          image,
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: Text('OK'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}