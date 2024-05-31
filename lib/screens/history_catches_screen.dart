import 'package:flutter/material.dart';

class HistoryCatchesScreen extends StatefulWidget {
  @override
  _HistoryCatchesScreenState createState() => _HistoryCatchesScreenState();
}

class _HistoryCatchesScreenState extends State<HistoryCatchesScreen> {
  List<Catch> allCatches = [
    Catch(
      imageId: '1',
      description: 'First catch description',
      title: 'First catch',
      createdAt: DateTime.now(),
    ),
    Catch(
      imageId: '2',
      description: 'Second catch description',
      title: 'Second catch',
      createdAt: DateTime.now(),
    ),
    // Add more catches here
  ];

  List<Catch> filteredCatches = [];

  @override
  void initState() {
    super.initState();
    filteredCatches = allCatches;
  }

  void filterCatches(String query) {
    setState(() {
      filteredCatches = allCatches
          .where((catchItem) =>
              catchItem.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History Catches'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: filterCatches,
              decoration: InputDecoration(
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredCatches.length,
              itemBuilder: (context, index) {
                final catchItem = filteredCatches[index];
                return ListTile(
                  title: Text(catchItem.title),
                  subtitle: Text(catchItem.description),
                  trailing: Text(catchItem.createdAt.toString()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Catch {
  final String imageId;
  final String description;
  final String title;
  final DateTime createdAt;

  Catch({
    required this.imageId,
    required this.description,
    required this.title,
    required this.createdAt,
  });
}