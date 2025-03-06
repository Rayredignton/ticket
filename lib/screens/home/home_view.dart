import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ticket/data/viewmodels/events_viewmodel.dart';
import 'package:ticket/widgets/event_list.dart';
import 'package:ticket/widgets/search_bar.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _currentPage = 1;
  final int _pageSize = 10;
  final ScrollController _scrollController = ScrollController();
  bool _isFetchingMore = false; // Prevents multiple calls

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<EventsViewmodel>(context, listen: false).fetchEvents();
    });
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final eventProvider = Provider.of<EventsViewmodel>(context, listen: false);
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isFetchingMore &&
        !eventProvider.isLoading &&
        !eventProvider.isSearching) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    _isFetchingMore = true;
    final eventProvider = Provider.of<EventsViewmodel>(context, listen: false);
    _currentPage++;
    await eventProvider.fetchEvents();
    _isFetchingMore = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ticket Mobile')),
      body: Column(
        children: [
          SearchBarWidget(),
          Expanded(
            child: EventList(scrollController: _scrollController),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}