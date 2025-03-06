import 'package:flutter/material.dart';
import 'package:ticket/widgets/commoan_modal_sheet.dart';


class NetworkUnavailableSheet extends StatelessWidget {
  const NetworkUnavailableSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: const CommonModalSheet(
        title: 'No Internet Connection',
        subtitle: 'You are now Viewing offline',
        isButtonAvailable: false,
    
        imagePath: 'res/images/offline1.png',
      ),
    );
  }
}

class NetworkAvailableSheet extends StatelessWidget {
  const NetworkAvailableSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: const CommonModalSheet(
        title: 'Internet Connection is back',
        // subtitle: 'Enjoy Zyggy',
        isButtonAvailable: false,
      
        imagePath: 'res/images/online1.png',
      ),
    );
  }
}
