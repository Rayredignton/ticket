import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/event_response.dart';

class EventRepository {
  final String apiKey = dotenv.env['TICKETMASTER_API_KEY'] ?? "";
   Dio dio = Dio();

  Future<EventResponse> fetchEvents(int page, int size) async {
    try {
      final url =
          'https://app.ticketmaster.com/discovery/v2/events.json?page=$page&size=$size&apikey=$apiKey';
      final response = await dio.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = response.data;
        final eventResponse = EventResponse.fromJson(json);
        print("Fetched events$eventResponse");
        await _cacheEvents(jsonEncode(json)); // Cache the fetched events
        return eventResponse;
      } else {
        throw Exception('Failed to load events');
      }
    } catch (e) {
      print("Fetch failed: $e. Trying cache...");
      final cachedData = await _getCachedEvents();
      if (cachedData != null) {
        print("Loaded from cache");
        return EventResponse.fromJson(jsonDecode(cachedData));
      }
      throw Exception('No cached data available');
    }
  }

  Future<EventResponse> searchEvents(String keyword) async {
    try {
      final url =
          'https://app.ticketmaster.com/discovery/v2/events.json?keyword=$keyword&apikey=$apiKey';
      final response = await dio.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = response.data;
        final eventResponse = EventResponse.fromJson(json);
        await _cacheSearchedEvents(jsonEncode(json)); 
        return eventResponse;
      } else {
        throw Exception('Failed to search events');
      }
    } catch (e) {
      print("Search failed: $e. Trying cache...");
      final cachedData = await _getCachedSearchedEvents();
      if (cachedData != null) {
        print("Loaded search results from cache");
        return EventResponse.fromJson(jsonDecode(cachedData));
      }
      throw Exception('No cached search data available');
    }
  }

  Future<void> _cacheEvents(String data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('cached_events', data);
  }

  Future<String?> _getCachedEvents() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('cached_events');
  }

  Future<void> _cacheSearchedEvents(String data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('cached_search_events', data);
  }

  Future<String?> _getCachedSearchedEvents() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('cached_search_events');
  }
}