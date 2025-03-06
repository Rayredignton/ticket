import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:ticket/data/models/event_model.dart';
import 'package:url_launcher/url_launcher.dart';

class EventDetailPage extends StatelessWidget {
  final Event event;

  const EventDetailPage({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          event.name,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.purpleAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                    SizedBox(height: 126),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    imageUrl: event.imageUrl ?? "",
                    cacheManager: CacheManager(
                      Config('customCacheKey',
                          stalePeriod: Duration(days: 7), maxNrOfCacheObjects: 100),
                    ),
                    placeholder: (context, url) => Container(
                      width: double.infinity,
                      height: 200,
                      color: Colors.grey[300],
                      child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                    ),
                    errorWidget: (context, url, error) => Container(
                      width: double.infinity,
                      height: 200,
                      color: Colors.grey[300],
                      child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
                    ),
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),

                SizedBox(height: 16),

                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 18, color: Colors.blueGrey),
                    SizedBox(width: 6),
                    Text(event.date ?? "Date not available",
                        style: TextStyle(fontSize: 16, color: Colors.blueGrey)),
                  ],
                ),

                SizedBox(height: 8),

                Row(
                  children: [
                    Icon(Icons.location_on, size: 18, color: Colors.redAccent),
                    SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        "${event.venue ?? 'Venue not available'}, ${event.address ?? 'Address not available'}",
                        style: TextStyle(fontSize: 16, color: Colors.blueGrey),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 12),

                Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Description",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 6),
                        Text(
                          event.description ?? "No description available",
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 80), // Add space for FAB
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _launchURL(event.ticketUrl ?? "https://www.ticketmaster.com"),
        icon: Icon(Icons.shopping_cart),
        label: Text("Buy Ticket"),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.inAppWebView);
    } else {
      throw 'Could not launch $url';
    }
  }
}
