import 'package:flutter/material.dart';
import '../controllers/note_controller.dart';
import '../models/note_model.dart';

class NoteDetailScreen extends StatefulWidget 
{
  final Note? note;
  const NoteDetailScreen({super.key, this.note});

  @override
  State<NoteDetailScreen> createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends State<NoteDetailScreen> 
{
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final NoteController _noteController = NoteController();

  bool _isSaving = false;

  @override
  void initState() 
  {
    super.initState();

    _titleController.text = widget.note?.title ?? '';
    _contentController.text = widget.note?.content ?? '';
  }

  @override
  void dispose() 
  {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _saveNote() async 
  {
    if (!_formKey.currentState!.validate() || _isSaving) 
    {
      return;
    }

    setState(() 
    {
      _isSaving = true;
    });

    try {
      final title = _titleController.text.trim();
      final content = _contentController.text.trim();

      if (widget.note == null) 
      {
        await _noteController.addNote(title, content);
      } 
      else 
      {
        await _noteController.updateNote(
          Note(
            id: widget.note!.id,
            title: title,
            content: content,
            createdAt: widget.note!.createdAt,
          ),
        );
      }

      if (!mounted) return;

      Navigator.pop(context);
    } 
    catch (e) 
    {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to save note: $e')));
    } 
    finally 
    {
      if (mounted) 
      {
        setState(() 
        {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) 
  {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note == null ? 'Add Note' : 'Edit Note'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),

                validator: (value) 
                {
                  if (value == null || value.trim().isEmpty) 
                  {
                    return 'Enter a title';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),
              TextFormField(
                controller: _contentController,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Content',
                  border: OutlineInputBorder(),
                ),

                validator: (value) 
                {
                  if (value == null || value.trim().isEmpty) 
                  {
                    return 'Enter some content';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isSaving ? null : _saveNote,
                child: _isSaving
                    ? const CircularProgressIndicator()
                    : const Text('Save Note'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
