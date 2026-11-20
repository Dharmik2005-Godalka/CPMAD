import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../models/event.dart';
import '../providers/event_provider.dart';
import '../utils/constants.dart';
import '../utils/extensions.dart';
import '../utils/validators.dart';
import '../widgets/app_text_field.dart';
import '../widgets/responsive_center.dart';

class EventFormScreen extends StatefulWidget {
  const EventFormScreen({super.key});

  @override
  State<EventFormScreen> createState() => _EventFormScreenState();
}

class _EventFormScreenState extends State<EventFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _organizerController = TextEditingController();

  String? _category;
  DateTime? _date;
  TimeOfDay? _time;
  String? _image;
  String? _categoryError;
  String? _dateError;
  bool _isSaving = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _organizerController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _date ?? now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (picked == null) return;
    setState(() {
      _date = picked;
      _dateError = null;
    });
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _time ?? TimeOfDay.now(),
    );
    if (picked == null) return;
    setState(() {
      _time = picked;
      _dateError = null;
    });
  }

  Future<void> _pickImage() async {
    try {
      final picked = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 600,
        maxHeight: 600,
        imageQuality: 60,
      );
      if (picked == null) return;

      final bytes = await picked.readAsBytes();
      if (!mounted) return;
      setState(() => _image = base64Encode(bytes));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not load the image')),
      );
    }
  }

  Future<void> _save() async {
    final formOk = _formKey.currentState!.validate();

    DateTime? dateTime;
    String? dateError;
    if (_date == null || _time == null) {
      dateError = 'Pick a date and time';
    } else {
      dateTime = DateTime(
        _date!.year, _date!.month, _date!.day, _time!.hour, _time!.minute,
      );
      if (!dateTime.isAfter(DateTime.now())) {
        dateError = 'The event must be in the future';
      }
    }

    setState(() {
      _categoryError = _category == null ? 'Select a category' : null;
      _dateError = dateError;
    });
    if (!formOk || _category == null || dateTime == null || dateError != null) {
      return;
    }

    final provider = context.read<EventProvider>();
    final messenger = ScaffoldMessenger.of(context);

    final event = Event(
      id: '',
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      location: _locationController.text.trim(),
      category: _category!,
      organizer: _organizerController.text.trim(),
      dateTime: dateTime,
      image: _image,
    );

    setState(() => _isSaving = true);

    try {
      await provider.addEvent(event);
      if (!mounted) return;
      Navigator.pop(context);
      messenger.showSnackBar(const SnackBar(content: Text('Event created')));
    } catch (_) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      messenger.showSnackBar(
        const SnackBar(content: Text('Could not save right now. Please try again.')),
      );
    }
  }

  ImageProvider? get _imageProvider {
    if (_image == null) return null;
    try {
      return MemoryImage(base64Decode(_image!));
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final image = _imageProvider;

    return Scaffold(
      appBar: AppBar(title: const Text('Create event')),
      body: SafeArea(
        child: ResponsiveCenter(
          maxWidth: 600,
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    height: 160,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(14),
                      image: image == null
                          ? null
                          : DecorationImage(image: image, fit: BoxFit.cover),
                    ),
                    child: image == null
                        ? const Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.add_photo_alternate, size: 40),
                                SizedBox(height: 6),
                                Text('Add event image (optional)'),
                              ],
                            ),
                          )
                        : null,
                  ),
                ),
                if (image != null)
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: () => setState(() => _image = null),
                      icon: const Icon(Icons.delete, size: 18),
                      label: const Text('Remove image'),
                    ),
                  ),
                const SizedBox(height: 16),
                AppTextField(
                  controller: _titleController,
                  label: 'Event title',
                  icon: Icons.title,
                  textInputAction: TextInputAction.next,
                  validator: (v) => Validators.required(v, 'event title'),
                ),
                AppTextField(
                  controller: _descriptionController,
                  label: 'Description',
                  icon: Icons.notes,
                  maxLines: 3,
                  validator: (v) => Validators.required(v, 'description'),
                ),
                AppTextField(
                  controller: _locationController,
                  label: 'Location',
                  icon: Icons.place,
                  textInputAction: TextInputAction.next,
                  validator: (v) => Validators.required(v, 'location'),
                ),
                AppTextField(
                  controller: _organizerController,
                  label: 'Organizer',
                  icon: Icons.groups,
                  textInputAction: TextInputAction.done,
                  validator: (v) => Validators.required(v, 'organizer'),
                ),
                _buildLabel('Category'),
                Wrap(
                  spacing: 8,
                  children: kEventCategories.map((c) {
                    return ChoiceChip(
                      label: Text(c),
                      selected: _category == c,
                      onSelected: (_) => setState(() {
                        _category = c;
                        _categoryError = null;
                      }),
                    );
                  }).toList(),
                ),
                _buildError(_categoryError),
                const SizedBox(height: 16),
                _buildLabel('Date & time'),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _pickDate,
                        icon: const Icon(Icons.calendar_today, size: 18),
                        label: Text(_date == null ? 'Pick date' : _date!.formatDate()),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _pickTime,
                        icon: const Icon(Icons.access_time, size: 18),
                        label: Text(_time == null ? 'Pick time' : _time!.format(context)),
                      ),
                    ),
                  ],
                ),
                _buildError(_dateError),
                const SizedBox(height: 24),
                SizedBox(
                  height: 48,
                  child: FilledButton(
                    onPressed: _isSaving ? null : _save,
                    child: _isSaving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text('Create event'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildError(String? message) {
    if (message == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Text(
        message,
        style: TextStyle(
          color: Theme.of(context).colorScheme.error,
          fontSize: 12,
        ),
      ),
    );
  }
}
