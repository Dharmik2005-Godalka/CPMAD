import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/note.dart';
import '../providers/note_provider.dart';
import '../widgets/responsive_center.dart';

enum _SaveStatus { idle, unsaved, saving, saved, error }

class NoteEditorScreen extends StatefulWidget {
  final Note? note;

  const NoteEditorScreen({super.key, this.note});

  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  static const int _maxChars = 1000;

  late final NoteProvider _provider;
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;

  Timer? _debounce;
  Note? _note;
  _SaveStatus _status = _SaveStatus.idle;
  bool _isSaving = false;
  bool _pendingSave = false;

  @override
  void initState() {
    super.initState();
    _provider = context.read<NoteProvider>();
    _note = widget.note;
    _titleController = TextEditingController(text: _note?.title ?? '');
    _contentController = TextEditingController(text: _note?.content ?? '');

    _titleController.addListener(_onChanged);
    _contentController.addListener(_onChanged);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    if (_status == _SaveStatus.unsaved && !_isSaving) {
      final title = _titleController.text.trim();
      final content = _contentController.text;
      if (title.isNotEmpty || content.trim().isNotEmpty) {
        _provider.save(existing: _note, title: title, content: content);
      }
    }
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _onChanged() {
    if (_status != _SaveStatus.unsaved) {
      setState(() => _status = _SaveStatus.unsaved);
    }
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 800), _autoSave);
  }

  Future<void> _autoSave() async {
    if (_isSaving) {
      _pendingSave = true;
      return;
    }

    final title = _titleController.text.trim();
    final content = _contentController.text;
    if (title.isEmpty && content.trim().isEmpty) {
      if (mounted) setState(() => _status = _SaveStatus.idle);
      return;
    }

    _isSaving = true;
    if (mounted) setState(() => _status = _SaveStatus.saving);

    try {
      _note = await _provider.save(
        existing: _note,
        title: title,
        content: content,
      );
      if (mounted && !_pendingSave) {
        setState(() => _status = _SaveStatus.saved);
      }
    } catch (_) {
      if (mounted) setState(() => _status = _SaveStatus.error);
    }

    _isSaving = false;
    if (_pendingSave) {
      _pendingSave = false;
      _autoSave();
    }
  }

  Widget _buildStatus() {
    switch (_status) {
      case _SaveStatus.saving:
        return const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            SizedBox(width: 6),
            Text('Saving...'),
          ],
        );
      case _SaveStatus.saved:
        return const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_done, size: 18, color: Colors.green),
            SizedBox(width: 6),
            Text('Saved'),
          ],
        );
      case _SaveStatus.unsaved:
        return const Text('Unsaved changes', style: TextStyle(color: Colors.grey));
      case _SaveStatus.error:
        return const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 18, color: Colors.red),
            SizedBox(width: 6),
            Text('Not saved'),
          ],
        );
      case _SaveStatus.idle:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note == null ? 'New note' : 'Edit note'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(child: _buildStatus()),
          ),
        ],
      ),
      body: SafeArea(
        child: ResponsiveCenter(
          maxWidth: 700,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: TextField(
                  controller: _titleController,
                  textInputAction: TextInputAction.next,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  decoration: const InputDecoration(
                    hintText: 'Title',
                    border: InputBorder.none,
                  ),
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    controller: _contentController,
                    maxLines: null,
                    expands: true,
                    textAlignVertical: TextAlignVertical.top,
                    inputFormatters: [LengthLimitingTextInputFormatter(_maxChars)],
                    decoration: const InputDecoration(
                      hintText: 'Start writing...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),  
            
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 10),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: ValueListenableBuilder<TextEditingValue>(
                    valueListenable: _contentController,
                    builder: (context, value, _) {
                      final count = value.text.length;
                      return Text(
                        '$count / $_maxChars',
                        style: TextStyle(
                          fontSize: 12,
                          color: count >= _maxChars * 0.9 ? Colors.red : Colors.grey,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
