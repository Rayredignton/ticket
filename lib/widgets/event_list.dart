import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:ticket/data/viewmodels/events_viewmodel.dart';
import 'event_tile.dart';

class EventList extends StatelessWidget {
  final ScrollController scrollController;

  const EventList({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return Consumer<EventsViewmodel>(
      builder: (context, eventProvider, child) {
        final events = eventProvider.isSearching
            ? eventProvider.searchedEvents
            : eventProvider.events;

        if (eventProvider.isLoading && events.isEmpty) {
          return Center(child: SpinKitCircle(
          color: Colors.blue,
        ),);
        }

        return Column(
          children: [
            /// **🔴 Offline Banner**
            if (eventProvider.isOffline)
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 8),
                color: Colors.redAccent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.cloud_off, color: Colors.white, size: 18),
                    SizedBox(width: 8),
                    Text(
                      "You are offline. Viewing cached events.",
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ],
                ),
              ),

            /// **📜 Event List**
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                physics: AlwaysScrollableScrollPhysics(),
                itemCount: events.length + 1,
                itemBuilder: (context, index) {
                  if (index < events.length) {
                    return EventTile(event: events[index]);
                  } else {
                    return eventProvider.isLoading
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(child: SpinKitCircle(
          color: Colors.blue,
        ),),
                          )
                        : SizedBox.shrink();
                  }
                },
              ),
            ),
          ],
        );
      },
    );
  }
}