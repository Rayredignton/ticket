import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticket/data/repos/events_repo.dart';
import 'dart:ui';

import 'event_provider_test.mocks.dart';

// Custom Matcher for queryParameters
class _KeywordMatcher extends Matcher {
  final String expectedKeyword;

  _KeywordMatcher(this.expectedKeyword);

  @override
  bool matches(dynamic item, Map matchState) {
    return item is Map && item['keyword'] == expectedKeyword;
  }

  @override
  Description describe(Description description) {
    return description.add('a Map with keyword: "$expectedKeyword"');
  }
}

@GenerateMocks([Dio, SharedPreferences])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockDio mockDio;
  late MockSharedPreferences mockPrefs;
  late EventRepository eventRepository;

  setUpAll(() async {
    await dotenv.load(fileName: ".env");
  });

  setUp(() {
    mockDio = MockDio();
    mockPrefs = MockSharedPreferences();

    when(mockDio.options).thenReturn(BaseOptions(
      baseUrl: 'https://example.com',
      connectTimeout: Duration(seconds: 5),
      receiveTimeout: Duration(seconds: 5),
    ));

    eventRepository = EventRepository(dio: mockDio, prefs: mockPrefs);

    when(mockPrefs.getString(any)).thenReturn(null);
    when(mockPrefs.setString(any, any)).thenAnswer((_) async => true);
  });

  group('EventRepository Tests', () {
    test('fetchEvents() returns data from API', () async {
      print("🛠️ Running fetchEvents() - API response test");

      final fakeResponse = {
        "_embedded": {
          "events": [
            {"id": "1", "name": "Test Event", "dates": {}, "images": []}
          ]
        }
      };

      when(mockDio.get(
        argThat(contains('/events')),
        queryParameters: anyNamed('queryParameters'),
      )).thenAnswer(
        (_) async => Response(
          data: fakeResponse,
          statusCode: 200,
          requestOptions: RequestOptions(path: '/events'),
        ),
      );

      final result = await eventRepository.fetchEvents(1, 20);

      print("API returned event: ${result.events.first.name}");

      expect(result.events, isNotEmpty);
      expect(result.events.first.name, equals("Test Event"));
      verify(mockPrefs.setString('cached_events', any)).called(1);
    });

    test('fetchEvents() loads from cache when offline', () async {
      print("🛠️ Simulating network failure for fetchEvents()...");

      when(mockDio.get(any, queryParameters: anyNamed('queryParameters')))
          .thenThrow(DioException(
        requestOptions: RequestOptions(path: '/events'),
        type: DioExceptionType.connectionTimeout,
        error: 'Timeout Error',
      ));

      final cachedData = jsonEncode({
        "_embedded": {
          "events": [
            {"id": "2", "name": "Cached Event", "dates": {}, "images": []}
          ]
        }
      });

      when(mockPrefs.getString('cached_events')).thenReturn(cachedData);

      print("🛠️ Fetching cached events...");
      final result = await eventRepository.fetchEvents(1, 20);

      print("Retrieved cached event: ${result.events.first.name}");
      expect(result.events, isNotEmpty);
      expect(result.events.first.name, equals("Cached Event"));
    }, timeout: Timeout(Duration(seconds: 10)));

    test('fetchEvents() throws an exception when no cache is available', () async {
      print("🛠️ Testing fetchEvents() with no API and no cache...");

      when(mockDio.get(any, queryParameters: anyNamed('queryParameters')))
          .thenThrow(DioException(
        requestOptions: RequestOptions(path: '/events'),
        type: DioExceptionType.connectionTimeout,
        error: 'Timeout Error',
      ));

      when(mockPrefs.getString('cached_events')).thenReturn(null);

      expect(() async => await eventRepository.fetchEvents(1, 20), throwsException);
      print(" Correctly threw exception when no cache available");
    });

    test('searchEvents() returns results from API', () async {
      print("🛠️ Running searchEvents() - API response test");

      final fakeSearchResponse = {
        "_embedded": {
          "events": [
            {"id": "3", "name": "Searched Event", "dates": {}, "images": []}
          ]
        }
      };

      when(mockDio.get(
        '/events',
        queryParameters: argThat(
          _KeywordMatcher('Concert'),
          named: 'queryParameters',
        ),
      )).thenAnswer(
        (_) async => Response(
          data: fakeSearchResponse,
          statusCode: 200,
          requestOptions: RequestOptions(path: '/events'),
        ),
      );

      final result = await eventRepository.searchEvents("Concert");

      print("✅ API returned search result: ${result.events.first.name}");

      expect(result.events, isNotEmpty);
      expect(result.events.first.name, equals("Searched Event"));
      verify(mockPrefs.setString('cached_search_events', any)).called(1);
    });

    test('searchEvents() loads from cache on failure', () async {
      print("🛠️ Simulating searchEvents() failure...");

      when(mockDio.get(any, queryParameters: anyNamed('queryParameters')))
          .thenThrow(DioException(
        requestOptions: RequestOptions(path: '/events/search'),
        type: DioExceptionType.connectionTimeout,
        error: 'Timeout Error',
      ));

      final cachedSearchData = jsonEncode({
        "_embedded": {
          "events": [
            {"id": "4", "name": "Cached Search Event", "dates": {}, "images": []}
          ]
        }
      });

      when(mockPrefs.getString('cached_search_events')).thenReturn(cachedSearchData);

      print("🛠️ Fetching cached search results...");
      final result = await eventRepository.searchEvents("Concert");

      print("Cached search result: ${result.events.first.name}");
      expect(result.events, isNotEmpty);
      expect(result.events.first.name, equals("Cached Search Event"));
    });
  });
}