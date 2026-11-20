import 'package:flutter/material.dart';
import '../models/event.dart';
import '../services/mock_event_service.dart';
import '../utils/extensions.dart';
import '../widgets/state_views.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  final MockEventService _service = MockEventService();
  late Future<List<Event>> _eventsFuture;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _eventsFuture = _service.fetchEvents();
  }

  void _reload() {
    setState(() {
      _eventsFuture = _service.fetchEvents();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Events'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Reload',
            onPressed: _reload,
          ),
        ],
      ),
      body: FutureBuilder<List<Event>>(
        future: _eventsFuture,
        builder: (context, snapshot) 
        {
          if (snapshot.connectionState == ConnectionState.waiting) 
          {
            return const LoadingView();
          }

          if (snapshot.hasError) {
            return ErrorView(
              message: 'Could not load events. Please try again.',
              onRetry: _reload,
            );
          }

          final events = snapshot.data ?? [];
          if (events.isEmpty) {
            return const EmptyView(
              icon: Icons.event_busy,
              message: 'No events yet',
            );
          }

          final results = events.search(_query); 

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search events',
                    prefixIcon: const Icon(Icons.search),
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: (value) => setState(() => _query = value),
                ),
              ),
              Expanded(
                child: results.isEmpty
                    ? const EmptyView(
                        icon: Icons.search_off,
                        message: 'No events match your search',
                      )
                    : ListView.builder(
                        itemCount: results.length,
                        itemBuilder: (context, index) {
                          final event = results[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            child: ListTile(
                              isThreeLine: true,
                              leading: const CircleAvatar(
                                child: Icon(Icons.event),
                              ),
                              title: Text(event.title),
                              subtitle: Text(
                                '${event.dateTime.relativeDay()}  •  ${event.dateTime.formatTime()}\n${event.location}',
                              ),
                              trailing: Text('${event.rsvpCount} going'),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
