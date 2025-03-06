import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:provider/provider.dart';
import 'package:ticket/data/viewmodels/connectivity_provider.dart';
import 'package:ticket/screens/home/home_view.dart';


final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

class TicketMobileApp extends StatefulWidget {
  const TicketMobileApp({super.key});

  @override
  State<TicketMobileApp> createState() => _TicketMobileAppState();
}

class _TicketMobileAppState extends State<TicketMobileApp> {
  Timer? _rootTimer;


  
 

  

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
              textScaler: TextScaler.linear(1.0)),
          child: MaterialApp(
   
                builder: (context, child) {
                  return ChangeNotifierProvider(
                    create: (context) => ConnectivityProvider(context),
                    lazy: false,
                    child: child!,
                  );
                },
            scaffoldMessengerKey: rootScaffoldMessengerKey,
           
            debugShowCheckedModeBanner: false,
            title: 'Ticket Mobile',
           
            home: child,
            themeMode: ThemeMode.light,
            navigatorKey: navigatorKey,
          ),
        );
      },
      child: Builder(builder: (context) {
        return  HomeView();
        // return const HomeView();
              
      }),
    );
  }
}
