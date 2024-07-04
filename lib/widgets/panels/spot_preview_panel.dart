import 'package:flutter/material.dart';

class SpotPreviewPanel extends StatelessWidget {
  final String username;
  final Widget image;
  final String location;

  SpotPreviewPanel(
      {required this.username, required this.image, required this.location});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {}, // Prevent tapping from dismissing the sheet
      onVerticalDragDown:
          (_) {}, // Prevent dragging down from dismissing the sheet
      child: DraggableScrollableSheet(
        initialChildSize: 0.6, // Set initial size of the sheet
        minChildSize: 0.3, // Set minimum size of the sheet
        maxChildSize: 0.9, // Set maximum size of the sheet
        builder: (BuildContext context, ScrollController scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.person),
                        const SizedBox(width: 8),
                        Text(username,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(location,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 16),
                    Expanded(
                      child: Center(
                          child:
                              image), // Center the image within the Expanded widget
                    ),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('OK'),
                      ),
                    ),
                  ],
                )),
          );
        },
      ),
    );
  }
}
