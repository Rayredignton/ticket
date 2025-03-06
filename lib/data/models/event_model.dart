class Event {
  final String name;
  final String? imageUrl;
  final String? date;
  final String? venue;
  final String? address;
  final String? description;
  final String? ticketUrl; // 🎟 Add ticket purchase URL

  Event({
    required this.name,
    this.imageUrl,
    this.date,
    this.venue,
    this.address,
    this.description,
    this.ticketUrl,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      name: json['name'] ?? 'Unknown Event',
      imageUrl: json['images'] != null && json['images'].isNotEmpty
          ? json['images'][0]['url']
          : null,
      date: json['dates']?['start']?['localDate'],
      venue: json['_embedded']?['venues']?[0]?['name'],
      address: json['_embedded']?['venues']?[0]?['address']?['line1'],
       description: json['description'] ?? json['info'] ?? json['pleaseNote'] ?? "No description available", 
      ticketUrl: json['url'], // ✅ Ticket purchase link from API
    );
  }
}