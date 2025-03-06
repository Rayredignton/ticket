import 'package:ticket/data/models/event_model.dart';

class EventSearchResult {
  final List<Event> events;

  EventSearchResult({required this.events});

  factory EventSearchResult.fromJson(Map<String, dynamic> json) {
    List<Event> eventsList = [];
    if (json['_embedded']?['events'] != null) {
      eventsList = (json['_embedded']['events'] as List)
          .map((eventJson) => Event.fromJson(eventJson))
          .toList();
    }

    return EventSearchResult(events: eventsList);
  }
}