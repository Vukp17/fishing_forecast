import 'package:fishingapp/models/spot_model.dart';
import 'package:fishingapp/services/spot_service.dart';
import 'package:fishingapp/widgets/feed/feed_card.dart';
import 'package:flutter/material.dart';

class FeedScreen extends StatefulWidget {
  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  late Future<List<Catch>> futureCatches;

  @override
  void initState() {
    super.initState();
    futureCatches = SpotService().getAllSpots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feed'),
      ),
      body: FutureBuilder<List<Catch>>(
        future: futureCatches,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('An error has occurred!'));
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (context, index) {
                final catchItem = snapshot.data?[index];
                return FeedCard(catchItem: catchItem!);
              },
            );
          }
        },
      ),
    );
  }
}