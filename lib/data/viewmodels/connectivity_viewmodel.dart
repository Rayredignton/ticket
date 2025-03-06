import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:ticket/app.dart';
import 'package:ticket/data/services/connectivity_service.dart';
import 'package:ticket/widgets/network_changes_sheet.dart';
import 'package:ticket/widgets/utils.dart';


//ConnectivityProvider -- For real-time internet connectivity notifications
class ConnectivityViewmodel extends ChangeNotifier {

  //InternetConnectivty -- Custom Singleton to listen to network connection changes
  final InternetConnectivity connectivity = InternetConnectivity.instance;

  //isOffline -- Boolean to check current network connection status
  //null -- if null, app has never gone offline till last run
  //true -- app is offline
  //false -- app is Online and was offline before
  bool? isOffline;

  ConnectivityViewmodel(context) {
    //Initializing Custom Singleton for listening connection changes
    connectivity.initialise();

    //Listening to connection stream for connection updates/changes
    connectivity.networkChangesStream.listen((source) {
      //Switch Case -- To take desired action in respect to network states
      switch (source.keys.toList()[0]) {
        //No Connection or Offline State
        case ConnectivityResult.none:
          if (isOffline == null || isOffline == false) {
            isOffline = true;
            notifyListeners();
            Utils.showAppBottomSheet(
              
              context: navigatorKey.currentContext!,
              builder: (p0) {
                return const NetworkUnavailableSheet();
              },
            );
              Future.delayed(const Duration(seconds: 4)).then((value) {
               navigatorKey.currentState!.pop();
    
      });
          }
          break;
        //Connected via Cellular Data
        case ConnectivityResult.mobile:
          backOnlineSheet();
          break;
        //Connected via WiFi Connection
        case ConnectivityResult.wifi:
          backOnlineSheet();
          break;
        //Connected via Ethernet Connection
        case ConnectivityResult.ethernet:
          backOnlineSheet();
          break;
        case ConnectivityResult.bluetooth:
          backOnlineSheet();
          break;
        case ConnectivityResult.vpn:
          backOnlineSheet();
          break;
        case ConnectivityResult.other:
      backOnlineSheet();
          break;
      }
    });
  }

  //Show Network is Back Sheet/Popup once the internet connection is available
  backOnlineSheet() {
    if (isOffline != null && isOffline == true) {
 

                  isOffline = false;
    

  
      Utils.showAppBottomSheet(
        context: navigatorKey.currentContext!,
        builder: (p0) {
          return const NetworkAvailableSheet();
        },
      );
        Future.delayed(const Duration(seconds: 2)).then((value) {
               navigatorKey.currentState!.pop();
    
      });
    
    }
    notifyListeners();
  }
}