import 'package:fishingapp/models/spot_model.dart';
import 'package:fishingapp/services/spot_service.dart';
import 'package:fishingapp/widgets/feed/feed_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


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
        title: Text( AppLocalizations.of(context)!.feed),
      ),
      body: _isLoading && catches.isEmpty
          ? Center(child: CircularProgressIndicator())
          : FeedListView(catches: catches, controller: _scrollController, isLoading: _isLoading),
    );
  }
}

class FeedListView extends StatelessWidget {
  final List<Catch> catches;
  final ScrollController controller;
  final bool isLoading;

  FeedListView({required this.catches, required this.controller, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: controller,
      itemCount: catches.length + (isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == catches.length) {
          return Center(child: CircularProgressIndicator());
        } else {
          final catchItem = catches[index];
          return FeedCard(catchItem: catchItem);
        }
      },
    );
  }
}