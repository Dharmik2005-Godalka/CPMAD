import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/event.dart';
import '../providers/event_provider.dart';
import '../utils/app_strings.dart';
import '../utils/extensions.dart';
import '../widgets/event_image.dart';
import '../widgets/responsive_center.dart';

class EventDetailsArgs {
  final Event event;
  final String heroTag;

  const EventDetailsArgs({required this.event, required this.heroTag});
}

class EventDetailsScreen extends StatelessWidget {
  final Event event;
  final String heroTag;

  const EventDetailsScreen({
    super.key,
    required this.event,
    required this.heroTag,
  });

  Future<void> _toggle(BuildContext context, EventProvider provider) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      await provider.toggleRsvp(event);
    } catch (_) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Could not update your RSVP')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);
    final provider = context.watch<EventProvider>();
    final going = provider.isGoing(event);

    return Scaffold(
      appBar: AppBar(title: Text(s.eventDetails)),
      body: ResponsiveCenter(
        maxWidth: 700,
        child: ListView(
          children: [
            Hero(
              tag: heroTag,
              child: EventImage(event: event, height: 220),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 12),
                  buildInfo(
                    Icons.calendar_today,
                    event.dateTime.formatDateTime(),
                  ),
                  buildInfo(Icons.place, event.location),
                  buildInfo(Icons.person, '${s.organizer}: ${event.organizer}'),
                  buildInfo(
                    Icons.people,
                    s.goingCount(provider.goingCount(event)),
                  ),
                  const SizedBox(height: 16),
                  Text(event.description),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: going
                        ? OutlinedButton.icon(
                            onPressed: () => _toggle(context, provider),
                            icon: const Icon(Icons.close),
                            label: Text(s.cancelRsvp),
                          )
                        : FilledButton.icon(
                            onPressed: () => _toggle(context, provider),
                            icon: const Icon(Icons.check),
                            label: Text(s.rsvp),
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildInfo(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
