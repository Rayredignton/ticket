import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ticket/app.dart';
import 'package:ticket/data/repos/events_repo.dart';
import 'package:ticket/data/viewmodels/events_viewmodel.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await dotenv.load();
  final sharedPreferences = await SharedPreferences.getInstance(); // ✅ Initialize SharedPreferences

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => EventsViewmodel(
            eventRepository: EventRepository(dio: Dio(), prefs: sharedPreferences),
          ),
        ),
      ],
      child: const TicketMobileApp(),
    ),
  );
}