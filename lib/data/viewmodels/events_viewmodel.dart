import 'package:flutter/foundation.dart';
import 'package:ticket/data/models/event_model.dart';
import 'package:ticket/data/repos/events_repo.dart';

class EventsViewmodel with ChangeNotifier {
  final EventRepository _eventRepository;

  EventsViewmodel({required EventRepository eventRepository}) 
      : _eventRepository = eventRepository;

  List<Event> _events = [];
  List<Event> _searchedEvents = [];
  bool _isOffline = false;
  bool _isLoading = false;
  bool _isSearching = false;

  List<Event> get events => _events;
  List<Event> get searchedEvents => _searchedEvents;
  bool get isOffline => _isOffline;
  bool get isLoading => _isLoading;
  bool get isSearching => _isSearching;

  /// Fetch events (loads from cache first if offline)
  Future<void> fetchEvents() async {
    _isLoading = true;
    notifyListeners();

    try {
      print("Calling fetchEvents()...");
      final eventResponse = await _eventRepository.fetchEvents(1, 20);

      if (eventResponse.events.isNotEmpty) {
        _events = eventResponse.events;
        print("Events fetched successfully! Count: ${_events.length}");
      } else {
        print("No events found in API response.");
      }
    } catch (e) {
      print("Error fetching events: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Search events based on a keyword
  Future<void> searchEvents(String keyword) async {
    if (keyword.isEmpty) {
      _searchedEvents = [];
      notifyListeners();
      return;
    }

    _isSearching = true;
    notifyListeners();

    try {
      final eventResponse = await _eventRepository.searchEvents(keyword);
      _searchedEvents = eventResponse.events;
    } catch (e) {
      print("Failed to search events, loading from cache...");
      _searchedEvents = [];
    }

    _isSearching = false;
    notifyListeners();
  }
}