import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:ticket/app.dart';
import 'package:ticket/data/viewmodels/events_viewmodel.dart';

Future<void> main() async {
    WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
runApp(
        (MultiProvider(
 
          providers:    [
    ChangeNotifierProvider(
      create: (context) => EventsViewmodel(),
    ),
   
  ],
          child: const TicketMobileApp(),
        )),
      );
}
