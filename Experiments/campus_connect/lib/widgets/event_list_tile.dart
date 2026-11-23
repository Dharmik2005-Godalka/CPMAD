import 'package:flutter/material.dart';
import '../models/event.dart';
import '../utils/extensions.dart';
import 'event_image.dart';
import 'sync_badge.dart';

class EventListTile extends StatelessWidget {
  final Event event;
  final String heroTag;
  final bool isPending;
  final bool isGoing;
  final VoidCallback? onTap; // null = not tappable (public API events)

  const EventListTile({
    super.key,
    required this.event,
    required this.heroTag,
    required this.isPending,
    required this.isGoing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: ListTile(
        onTap: onTap,
        isThreeLine: true,
        leading: SizedBox(
          width: 56,
          height: 56,
          child: Hero(
            tag: heroTag,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: EventImage(event: event, height: 56),
            ),
          ),
        ),
        title: Text(event.title, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Text(
          '${event.dateTime.relativeDay()}  •  ${event.dateTime.formatTime()}\n${event.location}',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: isPending
            ? const SyncBadge()
            : (isGoing
                ? Icon(
                    Icons.check_circle,
                    color: Theme.of(context).colorScheme.primary,
                  )
                : null),
      ),
    );
  }
}
