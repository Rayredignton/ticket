import 'package:ticket/data/models/event_model.dart';

class EventResponse {
  final List<Event> events;
  final PageInfo pageInfo;

  EventResponse({
    required this.events,
    required this.pageInfo,
  });

  factory EventResponse.fromJson(Map<String, dynamic> json) {
    List<Event> eventsList = [];
    if (json['_embedded']?['events'] != null) {
      eventsList = (json['_embedded']['events'] as List)
          .map((eventJson) => Event.fromJson(eventJson))
          .toList();
    }

    PageInfo pageInfo = PageInfo.fromJson(json['page'] ?? {});

    return EventResponse(
      events: eventsList,
      pageInfo: pageInfo,
    );
  }
}

class PageInfo {
  final int size;
  final int totalElements;
  final int totalPages;
  final int number;

  PageInfo({
    required this.size,
    required this.totalElements,
    required this.totalPages,
    required this.number, 
  });

  factory PageInfo.fromJson(Map<String, dynamic> json) {
    return PageInfo(
      size: json['size'] ?? 0,
      totalElements: json['totalElements'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
      number: json['number'] ?? 0, 
    );
  }
}