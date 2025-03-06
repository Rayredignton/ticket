import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ticket/data/viewmodels/events_viewmodel.dart';

class SearchBarWidget extends StatefulWidget {
  const SearchBarWidget({super.key});

  @override
  _SearchBarWidgetState createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(Duration(milliseconds: 500), () {
      _performSearch();
    });

    setState(() {}); // Update UI for clear icon visibility
  }

  void _performSearch() {
    final eventProvider = Provider.of<EventsViewmodel>(context, listen: false);
    String query = _controller.text.trim();


eventProvider.searchEvents(query);

    setState(() {}); // Refresh UI
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Row(
        children: [
          /// **Search Field**
          Expanded(
            child: TextField(
              controller: _controller,
              onChanged: _onSearchChanged,
              cursorColor: Colors.blueAccent,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: "Search events...",
                hintStyle: TextStyle(color: Colors.grey),
                contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                
                /// **Prefix Search Icon**
                prefixIcon: GestureDetector(
                  onTap: _performSearch,
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Icon(Icons.search, color: Colors.blueAccent),
                  ),
                ),

                /// **Dynamic Clear Button**
                suffixIcon: _controller.text.isNotEmpty
                    ? GestureDetector(
                        onTap: () {
                          _controller.clear();
                          _performSearch();
                        },
                        child: Padding(
                          padding: EdgeInsets.all(12),
                          child: Icon(Icons.clear, color: Colors.redAccent),
                        ),
                      )
                    : null,

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Colors.blueAccent, width: 1.5),
                ),
              ),
            ),
          ),

          SizedBox(width: 10),

          /// **Standalone Search Button**
          InkWell(
            onTap: _performSearch,
            borderRadius: BorderRadius.circular(50),
            child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: Colors.black26, blurRadius: 4),
                ],
              ),
              child: Icon(Icons.search, color: Colors.white, size: 28),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }
}