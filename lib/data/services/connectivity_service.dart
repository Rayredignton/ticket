import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

class InternetConnectivity {
  // Private Constructor for Singleton
  InternetConnectivity._internal();

  // Private Variable instance for setting up class instance
  static final InternetConnectivity _instance = InternetConnectivity._internal();

  // Getter instance to access Singleton methods via private instance variable
  static InternetConnectivity get instance => _instance;

  // Connectivity Plugin Object
  Connectivity connectivity = Connectivity();

  // Network Stream Controller to add and listen to Network Changes
  StreamController<Map<ConnectivityResult, bool>> networkStreamController =
      StreamController.broadcast();

  // Stream getter to notify network changes
  Stream<Map<ConnectivityResult, bool>> get networkChangesStream =>
      networkStreamController.stream;

  // Method to initialise the plugin and start listening to network updates/changes
  void initialise() {
    // Check initial connectivity status
    _checkConnectivity();

    // Listen for connectivity changes
    connectivity.onConnectivityChanged.listen((result) {
      _checkConnectivity();
    });
  }

  // Private method to check and update network status
  Future<void> _checkConnectivity() async {
    List<ConnectivityResult> results = await connectivity.checkConnectivity();
    for (var result in results) {
      await _checkStatus(result);
    }
  }

  // Private method to check network status by hitting google.com host
  Future<void> _checkStatus(ConnectivityResult result) async {
    bool isOnline = false;
    if (!kIsWeb) {
      try {
        final lookupResult = await InternetAddress.lookup('google.com');
        if (lookupResult.isNotEmpty && lookupResult.first.rawAddress.isNotEmpty) {
          isOnline = true;
        } else {
          isOnline = false;
        }
      } on SocketException catch (_) {
        isOnline = false;
      }
    }
    networkStreamController.add({result: isOnline});
  }

  void disposeStream() => networkStreamController.close();
}
