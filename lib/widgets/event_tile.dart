import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ticket/data/models/event_model.dart';
import 'package:ticket/widgets/event_detail_page.dart';

class EventTile extends StatelessWidget {
  final Event event;

  const EventTile({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 3,
        child: ListTile(
          
          contentPadding: EdgeInsets.all(12),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImage(
              imageUrl: event.imageUrl ?? "",
              cacheManager: CacheManager(
                Config('customCacheKey',
                    stalePeriod: const Duration(days: 7),
                    maxNrOfCacheObjects: 100),
              ),
              placeholder: (context, url) => Container(
                width: 50,
                height: 50,
                color: Colors.grey[300],
                child: Center(child: SpinKitCircle(
          color: Colors.blue,
        ),),
              ),
              errorWidget: (context, url, error) => Container(
                width: 50,
                height: 50,
                color: Colors.grey[300],
                child: Icon(Icons.broken_image, color: Colors.grey),
              ),
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
          ),
          title: Text(
            event.name,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 14, color: Colors.blueGrey),
                  SizedBox(width: 6),
                  Text(event.date ?? "Date not available",
                      style: TextStyle(fontSize: 14, color: Colors.blueGrey)),
                ],
              ),
              SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.location_city, size: 14, color: Colors.redAccent),
                  SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      event.venue ?? "Venue not available",
                      style: TextStyle(fontSize: 14, color: Colors.blueGrey),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.location_on, size: 14, color: Colors.redAccent),
                  SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      event.address ?? "Address not available",
                      style: TextStyle(fontSize: 14, color: Colors.blueGrey),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => EventDetailPage(event: event),
    ),
  );
},
        ),
      ),
    );
  }
}