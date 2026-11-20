import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/event.dart';
import '../utils/extensions.dart';

class EventCard extends StatelessWidget {
  final Event event;
  final bool isAttending;
  final VoidCallback onTap;
  final VoidCallback onRsvp;

  const EventCard({
    super.key,
    required this.event,
    required this.isAttending,
    required this.onTap,
    required this.onRsvp,
  });

  ImageProvider? get _image {
    final data = event.image;
    if (data == null || data.isEmpty) return null;
    try {
      return MemoryImage(base64Decode(data));
    } catch (_) {
      return null;
    }
  }

  IconData get _categoryIcon {
    switch (event.category) {
      case 'Tech':
        return Icons.computer;
      case 'Academic':
        return Icons.menu_book;
      case 'Cultural':
        return Icons.theater_comedy;
      case 'Sports':
        return Icons.sports_cricket;
      default:
        return Icons.event;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final ended = !event.isUpcoming;

    return Opacity(
      opacity: ended ? 0.6 : 1,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(
            color: isAttending ? colors.primary : Colors.transparent,
            width: 2,
          ),
        ),
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(colors, ended),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    _infoRow(
                      Icons.schedule,
                      '${event.dateTime.relativeDay()}  •  ${event.dateTime.formatTime()}',
                    ),
                    _infoRow(Icons.place, event.location),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${event.rsvpCount} going',
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ),
                        _buildAction(ended),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ColorScheme colors, bool ended) {
    final image = _image;

    return SizedBox(
      height: 120,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (image != null)
            Image(image: image, fit: BoxFit.cover)
          else
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [colors.primary, colors.tertiary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Icon(_categoryIcon, size: 56, color: Colors.white54),
            ),
          Positioned(top: 8, left: 8, child: _badge(event.category, Colors.black54)),
          if (ended)
            Positioned(top: 8, right: 8, child: _badge('Ended', Colors.grey.shade700))
          else if (isAttending)
            Positioned(top: 8, right: 8, child: _badge('Going', colors.primary)),
        ],
      ),
    );
  }

  Widget _badge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey),
          const SizedBox(width: 6),
          Expanded(child: Text(text, maxLines: 1, overflow: TextOverflow.ellipsis)),
        ],
      ),
    );
  }

  Widget _buildAction(bool ended) {
    if (ended) return const Text('Event ended', style: TextStyle(color: Colors.grey));

    if (isAttending) {
      return OutlinedButton.icon(
        onPressed: onRsvp,
        icon: const Icon(Icons.check, size: 18),
        label: const Text('Going'),
      );
    }

    return FilledButton.icon(
      onPressed: onRsvp,
      icon: const Icon(Icons.add, size: 18),
      label: const Text('RSVP'),
    );
  }
}
