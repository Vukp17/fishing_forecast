import 'package:fishingapp/models/spot_model.dart';
import 'package:fishingapp/services/spot_service.dart';
import 'package:fishingapp/widgets/feed/feed_card.dart';
import 'package:flutter/material.dart';

class FeedScreen extends StatefulWidget {
  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  List<Catch> catches = [];
  ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    _loadData();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      _loadData();
    }
  }

  void _loadData() async {
    if (!_isLoading) {
      setState(() {
        _isLoading = true;
      });

      List<Catch> newCatches = await SpotService().getMoreSpots(_currentPage);

      setState(() {
        catches.addAll(newCatches);
        _currentPage++;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feed'),
      ),
      body: _isLoading && catches.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              controller: _scrollController,
              itemCount: catches.length + (_isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == catches.length) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  final catchItem = catches[index];
                  return FeedCard(catchItem: catchItem);
                }
              },
            ),
    );
  }
}
