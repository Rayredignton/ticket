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
          return const Center(
            child: SpinKitCircle(
              color: Colors.blue,
              size: 50.0, // Adjust size for better visibility
            ),
          );
        }

        if (events.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "No events found. Try searching for something else!",
                style: TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        return Expanded(
          child: ListView.builder(
            controller: scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: events.length + 1, // +1 for the loading indicator
            itemBuilder: (context, index) {
              if (index < events.length) {
                return EventTile(event: events[index]);
              } else {
                return eventProvider.isLoading
                    ? const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Center(
                          child: SpinKitCircle(
                            color: Colors.blue,
                            size: 40.0,
                          ),
                        ),
                      )
                    : const SizedBox.shrink();
              }
            },
          ),
        );
      },
    );
  }
}