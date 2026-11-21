import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/event.dart';
import '../providers/event_provider.dart';
import '../screens/event_details_screen.dart';
import '../utils/app_routes.dart';
import 'event_card.dart';
import 'state_views.dart';

class EventList extends StatelessWidget {
  final List<Event> events;
  final String heroPrefix;
  final IconData emptyIcon;
  final String emptyMessage;

  const EventList({
    super.key,
    required this.events,
    required this.heroPrefix,
    required this.emptyIcon,
    required this.emptyMessage,
  });

  @override
  Widget build(BuildContext context) {
    if (events.isEmpty) {
      return EmptyView(icon: emptyIcon, message: emptyMessage);
    }

    final provider = context.watch<EventProvider>();

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 16),
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];

        return EventCard(
          event: event,
          isAttending: provider.isGoing(event),
          onTap: () {
            Navigator.pushNamed(
              context,
              AppRoutes.eventDetails,
              arguments: EventDetailsArgs(
                event: event,
                heroTag: '$heroPrefix-${event.id}',
              ),
            );
          },
          onRsvp: () async {
            final messenger = ScaffoldMessenger.of(context);
            try {
              await provider.toggleRsvp(event);
            } catch (_) {
              messenger.showSnackBar(
                const SnackBar(content: Text('Could not update your RSVP')),
              );
            }
          },
        );
      },
    );
  }
}
