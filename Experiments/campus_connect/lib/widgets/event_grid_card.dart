import 'package:flutter/material.dart';
import '../models/event.dart';
import '../utils/extensions.dart';
import 'event_image.dart';
import 'sync_badge.dart';

class EventGridCard extends StatelessWidget {
  final Event event;
  final String heroTag;
  final bool isPending;
  final bool isGoing;
  final VoidCallback onTap;

  const EventGridCard({
    super.key,
    required this.event,
    required this.heroTag,
    required this.isPending,
    required this.isGoing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: heroTag,
                    child: EventImage(event: event, height: 100),
                  ),
                  if (isPending)
                    const Positioned(top: 6, left: 6, child: SyncBadge()),
                  if (isGoing)
                    const Positioned(
                      top: 6,
                      right: 6,
                      child: CircleAvatar(
                        radius: 12,
                        child: Icon(Icons.check, size: 14),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${event.dateTime.relativeDay()}  •  ${event.dateTime.formatTime()}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
