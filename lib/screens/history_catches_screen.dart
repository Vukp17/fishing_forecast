import 'package:fishingapp/models/spot_model.dart';
import 'package:fishingapp/services/map_service.dart';
import 'package:fishingapp/services/spot_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistoryCatchesScreen extends StatefulWidget {
  @override
  _HistoryCatchesScreenState createState() => _HistoryCatchesScreenState();
}

class _HistoryCatchesScreenState extends State<HistoryCatchesScreen> {
  List<Catch> allCatches = [];

  List<Catch> filteredCatches = [];

  @override
  void initState() {
    super.initState();
    filteredCatches = allCatches;
    loadCatches();
  }

  void filterCatches(String query) {
    setState(() {
      filteredCatches = allCatches
          .where((catchItem) =>
              catchItem.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  Future<void> loadCatches() async {
    try {
      final spots = await SpotService().getSpots();
      setState(() {
        allCatches = spots;
        filteredCatches = allCatches;
      });
    } catch (e) {
      print('Failed to load catches: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.history), // Add icon
            SizedBox(width: 5), // Add spacing
            Text('History Catches'),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: filterCatches,
              decoration: InputDecoration(
                labelText: 'Search',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white.withOpacity(0.5)),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white.withOpacity(0.5)),
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                hintText: 'Search catches',
                hintStyle: const TextStyle(color: Colors.grey),
                suffixIcon: const Icon(Icons.clear, color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(height: 10), // Add spacing
          Expanded(
            child: ListView.builder(
              itemCount: filteredCatches.length,
              itemBuilder: (context, index) {
                final catchItem = filteredCatches[index];
                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10), // Add shape
                  ),
                  margin: const EdgeInsets.symmetric(
                      vertical: 5, horizontal: 10), // Add spacing
                  child: ListTile(
                    title: Text(catchItem.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          catchItem.description.length > 20
                              ? '${catchItem.description.substring(0, 20)}..'
                              : catchItem.description,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF42d9c8),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.all(5),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.water, color: Colors.white),
                              SizedBox(width: 5),
                              Text(
                                'carp',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    trailing: Text(
                      DateFormat('dd/MM/yyyy HH:mm')
                          .format(catchItem.created_at),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
