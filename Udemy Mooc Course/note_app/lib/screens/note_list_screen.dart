import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../controllers/note_controller.dart';
import '../models/note_model.dart';
import 'note_detail_screen.dart';

class NoteListScreen extends StatefulWidget {
  const NoteListScreen({super.key});

  @override
  State<NoteListScreen> createState() => _NoteListScreenState();
}

class _NoteListScreenState extends State<NoteListScreen> {
  final NoteController _noteController = NoteController();
  late Future<List<Note>> _noteList;

  @override
  void initState() 
  {
    super.initState();
    _loadNotes();
  }

  void _loadNotes() 
  {
    _noteList = _noteController.getNotes();
  }

  Future<void> _openNote([Note? note]) async 
  {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => NoteDetailScreen(note: note)),
    );

    if (mounted) 
    {
      setState(_loadNotes);
    }
  }

  @override
  Widget build(BuildContext context) 
  {
    return Scaffold(
      appBar: AppBar(title: const Text('Notes')),
      body: FutureBuilder<List<Note>>(
        future: _noteList,
        builder: (context, snapshot) 
        {
          if (snapshot.connectionState == ConnectionState.waiting) 
          {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) 
          {
            return Center(
              child: Text('Failed to load notes: ${snapshot.error}'),
            );
          }

          final notes = snapshot.data ?? [];

          if (notes.isEmpty) 
          {
            return const Center(child: Text('No notes yet'));
          }

          return ListView.builder(
            itemCount: notes.length,
            itemBuilder: (context, index) 
            {
              final note = notes[index];

              return ListTile(
                title: Text(note.title),
                subtitle: Text(
                  DateFormat('dd/MM/yyyy hh:mm a').format(note.createdAt),
                ),
                onTap: () => _openNote(note),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    await _noteController.deleteNote(note.id!);

                    if (mounted) {
                      setState(_loadNotes);
                    }
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openNote(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
