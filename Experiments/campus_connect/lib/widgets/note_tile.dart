import 'package:flutter/material.dart';
import '../models/note.dart';
import '../utils/extensions.dart';

class NoteTile extends StatelessWidget {
  final Note note;
  final VoidCallback onTap;
  final VoidCallback onTogglePin;

  const NoteTile({
    super.key,
    required this.note,
    required this.onTap,
    required this.onTogglePin,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final pinned = note.isPinned;
    final empty = note.content.trim().isEmpty;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      color: pinned ? colors.primaryContainer : null,
      child: ListTile(
        onTap: onTap,
        isThreeLine: true,
        leading: Icon(
          pinned ? Icons.push_pin : Icons.sticky_note_2_outlined,
          color: pinned ? colors.primary : Colors.grey,
        ),
        title: Text(
          note.title.isEmpty ? 'Untitled' : note.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              empty ? 'No content' : note.content,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontStyle: empty ? FontStyle.italic : FontStyle.normal,
                color: empty ? Colors.grey : null,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Edited ${note.updatedAt.timeAgo()}  •  ${note.content.length} chars',
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
        trailing: IconButton(
          tooltip: pinned ? 'Unpin' : 'Pin',
          icon: Icon(pinned ? Icons.push_pin : Icons.push_pin_outlined),
          onPressed: onTogglePin,
        ),
      ),
    );
  }
}
