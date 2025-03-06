import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ticket/data/models/event_model.dart';

class EventCard extends StatelessWidget {
  final Event event;

  const EventCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CachedNetworkImage(
            imageUrl: event.imageUrl??"",
            placeholder: (context, url) => Center(
              child: CircularProgressIndicator(),
            ),
            errorWidget: (context, url, error) => Icon(Icons.broken_image),
            fit: BoxFit.cover,
            width: double.infinity,
            height: 200,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              event.name,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}