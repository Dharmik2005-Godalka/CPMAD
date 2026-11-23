import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/note_provider.dart';
import '../utils/app_strings.dart';
import '../utils/extensions.dart';
import '../widgets/state_views.dart';
import '../widgets/skeleton.dart';

class NotesTab extends StatelessWidget 
{
  const NotesTab({super.key});

  @override
  Widget build(BuildContext context) 
  {
    final s = AppStrings.of(context);
    final provider = context.watch<NoteProvider>();

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context),
        tooltip: s.addNote,
        child: const Icon(Icons.add),
      ),
      body: buildBody(provider, s),
    );
  }

  Widget buildBody(NoteProvider provider, AppStrings s) 
  {
    if (provider.isLoading) return const SkeletonList();

    final notes = provider.notes;

    if (notes.isEmpty) 
    {
      return EmptyView(
        icon: Icons.edit_note,
        message: s.noNotes,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 90),
      itemCount: notes.length,
      itemBuilder: (context, index) 
      {
        final note = notes[index];

        return Card(
          margin: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 6,
          ),
          child: ListTile(
            title: Text(
              note.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              '${note.content}\n${note.updatedAt.timeAgo()}',
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            isThreeLine: true,
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () => provider.deleteNote(note.id),
            ),
          ),
        );
      },
    );
  }

  void _showAddDialog(BuildContext context) {
    final s = AppStrings.of(context);
    final formKey = GlobalKey<FormState>();
    final titleController = TextEditingController();
    final contentController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(s.addNote),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: s.noteTitle,
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty)
                        ? s.enterTitle
                        : null,
              ),
              TextField(
                controller: contentController,
                decoration: InputDecoration(
                  labelText: s.noteContent,
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(s.cancel),
          ),
          TextButton(
            onPressed: () async {
              if (!formKey.currentState!.validate()) {
                return;
              }

              try {
                await context.read<NoteProvider>().save(
                  title: titleController.text.trim(),
                  content: contentController.text.trim(),
                );

                if (ctx.mounted) {
                  Navigator.pop(ctx);
                }
              } catch (e) {
                debugPrint('Error saving note: $e');
              }
            },
            child: Text(s.save),
          ),
        ],
      ),
    ).then((_) {
      titleController.dispose();
      contentController.dispose();
    });
  }
}
