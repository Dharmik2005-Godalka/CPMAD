import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/note_provider.dart';
import '../utils/app_routes.dart';
import '../utils/constants.dart';
import '../widgets/note_tile.dart';
import '../widgets/state_views.dart';

class NotesScreen extends StatelessWidget {
  const NotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NoteProvider>();

    return Scaffold(
      appBar: AppBar(title: Text('Notes (${provider.notes.length})')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, AppRoutes.noteEditor),
        icon: const Icon(Icons.edit),
        label: const Text('New note'),
      ),
      body: _buildBody(context, provider),
    );
  }

  Widget _buildBody(BuildContext context, NoteProvider provider) {
    if (provider.isLoading) return const LoadingView();

    if (provider.error != null) {
      return ErrorView(message: provider.error!, onRetry: provider.retry);
    }

    if (provider.notes.isEmpty) {
      return const EmptyView(
        icon: Icons.note_alt_outlined,
        message: 'No notes yet.\nTap New note to write your first one.',
      );
    }

    final notes = provider.filteredNotes;
    final messenger = ScaffoldMessenger.of(context);

    return Column(
      children: [
        const _NoteFilters(),
        Expanded(
          child: notes.isEmpty
              ? const EmptyView(
                  icon: Icons.search_off,
                  message: 'No notes match your search',
                )
              : ListView.builder(
                  padding: const EdgeInsets.only(bottom: 90),
                  itemCount: notes.length,
                  itemBuilder: (context, index) {
                    final note = notes[index];
                    return Dismissible(
                      key: ValueKey(note.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 24),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      confirmDismiss: (_) => _confirmDelete(context),
                      onDismissed: (_) async {
                        try {
                          await provider.deleteNote(note.id);
                          messenger.showSnackBar(
                            const SnackBar(content: Text('Note deleted')),
                          );
                        } catch (_) {
                          messenger.showSnackBar(
                            const SnackBar(content: Text('Could not delete the note')),
                          );
                        }
                      },
                      child: NoteTile(
                        note: note,
                        onTap: () => Navigator.pushNamed(
                          context,
                          AppRoutes.noteEditor,
                          arguments: note,
                        ),
                        onTogglePin: () => provider.togglePin(note),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Future<bool> _confirmDelete(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete note'),
        content: const Text('This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    return ok ?? false;
  }
}

class _NoteFilters extends StatelessWidget {
  const _NoteFilters();

  @override
  Widget build(BuildContext context) {
    final filter = context.select<NoteProvider, NoteFilter>((p) => p.filter);
    final provider = context.read<NoteProvider>();

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: 'Search notes',
              prefixIcon: const Icon(Icons.search),
              isDense: true,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onChanged: provider.setSearchQuery,
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: SegmentedButton<NoteFilter>(
              showSelectedIcon: false,
              segments: const [
                ButtonSegment(value: NoteFilter.all, label: Text('All')),
                ButtonSegment(
                  value: NoteFilter.pinned,
                  icon: Icon(Icons.push_pin, size: 16),
                  label: Text('Pinned'),
                ),
              ],
              selected: {filter},
              onSelectionChanged: (s) => provider.setFilter(s.first),
            ),
          ),
        ],
      ),
    );
  }
}
