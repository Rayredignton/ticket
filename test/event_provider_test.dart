import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticket/data/repos/events_repo.dart';

import 'dart:ui';
// Generate Mocks
import 'event_provider_test.mocks.dart';


@GenerateMocks([Dio, SharedPreferences])
void main() {
  late MockDio mockDio;
  late MockSharedPreferences mockPrefs;
  late EventRepository eventRepository;

  setUp(() {
    mockDio = MockDio();
    mockPrefs = MockSharedPreferences();
    eventRepository = EventRepository();
    eventRepository = EventRepository()..dio = mockDio; // Inject mock Dio
  });

  group('EventRepository Tests', () {
    test('fetchEvents() returns data from API', () async {
      // Sample API response
      final fakeResponse = {
        "_embedded": {
          "events": [
            {"id": "1", "name": "Test Event", "dates": {}, "images": []}
          ]
        }
      };

      // Mock Dio request to return this fake response
      when(mockDio.get(any)).thenAnswer(
        (_) async => Response(
          data: fakeResponse,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      final result = await eventRepository.fetchEvents(1, 20);

      expect(result.events, isNotEmpty);
      expect(result.events.first.name, equals("Test Event"));
    });

    test('fetchEvents() loads from cache when offline', () async {
      // Simulate API failure
      when(mockDio.get(any)).thenThrow(DioException(
        requestOptions: RequestOptions(path: ''),
        type: DioExceptionType.connectionTimeout,
      ));

      // Mock cached data
      final cachedData = jsonEncode({
        "_embedded": {
          "events": [
            {"id": "2", "name": "Cached Event", "dates": {}, "images": []}
          ]
        }
      });

      when(mockPrefs.getString('cached_events')).thenReturn(cachedData);

      final result = await eventRepository.fetchEvents(1, 20);

      expect(result.events, isNotEmpty);
      expect(result.events.first.name, equals("Cached Event"));
    });

    test('fetchEvents() throws an exception when no cache is available', () async {
      when(mockDio.get(any)).thenThrow(DioException(
        requestOptions: RequestOptions(path: ''),
        type: DioExceptionType.connectionTimeout,
      ));

      when(mockPrefs.getString('cached_events')).thenReturn(null);

      expect(() async => await eventRepository.fetchEvents(1, 20),
          throwsException);
    });

    test('searchEvents() returns results from API', () async {
      final fakeSearchResponse = {
        "_embedded": {
          "events": [
            {"id": "3", "name": "Searched Event", "dates": {}, "images": []}
          ]
        }
      };

      when(mockDio.get(any)).thenAnswer(
        (_) async => Response(
          data: fakeSearchResponse,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      final result = await eventRepository.searchEvents("Concert");

      expect(result.events, isNotEmpty);
      expect(result.events.first.name, equals("Searched Event"));
    });

    test('searchEvents() loads from cache on failure', () async {
      when(mockDio.get(any)).thenThrow(DioException(
        requestOptions: RequestOptions(path: ''),
        type: DioExceptionType.connectionTimeout,
      ));

      final cachedSearchData = jsonEncode({
        "_embedded": {
          "events": [
            {"id": "4", "name": "Cached Search Event", "dates": {}, "images": []}
          ]
        }
      });

      when(mockPrefs.getString('cached_search_events'))
          .thenReturn(cachedSearchData);

      final result = await eventRepository.searchEvents("Concert");

      expect(result.events, isNotEmpty);
      expect(result.events.first.name, equals("Cached Search Event"));
    });
  });
}