import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/event_response.dart';

class EventRepository {
  final SharedPreferences prefs;
  final Dio dio;
//apply api key here, load from dotenv
  final String apiKey = dotenv.env['TICKETMASTER_API_KEY'] ?? ""; 
  final String baseUrl = "https://app.ticketmaster.com/discovery/v2";

  EventRepository({required this.dio, required this.prefs}) {

    // ✅ Instead, configure the existing `dio` instance properly
    dio.options.baseUrl = baseUrl;
    dio.options.connectTimeout = const Duration(seconds: 90);
    dio.options.receiveTimeout = const Duration(seconds: 90);
    dio.options.queryParameters = {
      'apikey': apiKey, // 
    };
  }

  Future<EventResponse> fetchEvents(int page, int size) async {
    try {
      print("Fetching events from API...");

      final response = await dio.get(
        '/events', //
        queryParameters: {
          'page': page,
          'size': size,
        },
      );

      print("✅ API Response: ${response.data}");

      await prefs.setString('cached_events', jsonEncode(response.data));
      return EventResponse.fromJson(response.data);
    } on DioException catch (e) {
      print(" Fetch failed: ${e.message}"); //

      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        print("⚠️ Timeout Error. Trying cache...");
        final cachedData = prefs.getString('cached_events');

        if (cachedData != null) {
          return EventResponse.fromJson(jsonDecode(cachedData));
        } else {
          throw Exception(" No cached events available");
        }
      }

      rethrow; // Propagate other errors
    }
  }
  Future<EventResponse> searchEvents(String query) async {
  try {
    print("🔍 Searching events with keyword: $query");

    final response = await dio.get(
      '/events',
      queryParameters: {
        'keyword': query,  
        'apikey': apiKey,  
      },
    );

    print(" Search API Response: ${response.data}");

    await prefs.setString('cached_search_events', jsonEncode(response.data));
    return EventResponse.fromJson(response.data);
  } on DioException catch (e) {
    print(" Search failed: ${e.message}");

    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      print(" Timeout. Trying cached search results...");

      final cachedData = prefs.getString('cached_search_events');
      if (cachedData != null) {
        return EventResponse.fromJson(jsonDecode(cachedData));
      } else {
        throw Exception(" No cached search results available");
      }
    }

    rethrow;
  }
}
}