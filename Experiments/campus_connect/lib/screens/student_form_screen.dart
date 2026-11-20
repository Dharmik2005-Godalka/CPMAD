import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../models/student.dart';
import '../providers/student_provider.dart';
import '../utils/constants.dart';
import '../utils/validators.dart';
import '../widgets/app_text_field.dart';
import '../widgets/responsive_center.dart';

// Used for both "Add student" (student == null) and "Edit student"
class StudentFormScreen extends StatefulWidget {
  final Student? student;

  const StudentFormScreen({super.key, this.student});

  @override
  State<StudentFormScreen> createState() => _StudentFormScreenState();
}

class _StudentFormScreenState extends State<StudentFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  late final TextEditingController _nameController;
  late final TextEditingController _rollController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;

  String? _department;
  String? _departmentError;
  int _year = 1;
  String? _photo; // base64
  bool _isSaving = false;

  bool get _isEdit => widget.student != null;

  // Camera is only offered on phones
  bool get _hasCamera =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);

  @override
  void initState() {
    super.initState();
    final s = widget.student;
    _nameController = TextEditingController(text: s?.name ?? '');
    _rollController = TextEditingController(text: s?.rollNo ?? '');
    _emailController = TextEditingController(text: s?.email ?? '');
    _phoneController = TextEditingController(text: s?.phone ?? '');
    _department = s?.department;
    _year = s?.year ?? 1;
    _photo = s?.photo;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _rollController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  // ---------- Photo (native feature) ----------
  Future<void> _pickPhoto(ImageSource source) async {
    try {
      final picked = await _picker.pickImage(
        source: source,
        maxWidth: 300, // keep it small so it fits in Firestore
        maxHeight: 300,
        imageQuality: 60,
      );
      if (picked == null) return;

      final bytes = await picked.readAsBytes();
      if (!mounted) return;
      setState(() => _photo = base64Encode(bytes));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not load the photo')),
      );
    }
  }

  void _showPhotoOptions() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from gallery'),
              onTap: () {
                Navigator.pop(ctx);
                _pickPhoto(ImageSource.gallery);
              },
            ),
            if (_hasCamera)
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Take a photo'),
                onTap: () {
                  Navigator.pop(ctx);
                  _pickPhoto(ImageSource.camera);
                },
              ),
            if (_photo != null)
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Remove photo'),
                onTap: () {
                  Navigator.pop(ctx);
                  setState(() => _photo = null);
                },
              ),
          ],
        ),
      ),
    );
  }

  // ---------- Save ----------
  Future<void> _save() async {
    final formOk = _formKey.currentState!.validate();
    setState(() {
      _departmentError = _department == null ? 'Select a department' : null;
    });
    if (!formOk || _department == null) return;

    final provider = context.read<StudentProvider>();
    final messenger = ScaffoldMessenger.of(context);
    final rollNo = _rollController.text.trim();

    if (provider.rollNoExists(rollNo, exceptId: widget.student?.id)) {
      messenger.showSnackBar(
        const SnackBar(
          content: Text('A student with this roll number already exists'),
        ),
      );
      return;
    }

    final student = Student(
      id: widget.student?.id ?? '',
      name: _nameController.text.trim(),
      rollNo: rollNo,
      department: _department!,
      year: _year,
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      photo: _photo,
    );

    setState(() => _isSaving = true);

    try {
      if (_isEdit) {
        await provider.updateStudent(student);
      } else {
        await provider.addStudent(student);
      }
      if (!mounted) return;
      Navigator.pop(context);
      messenger.showSnackBar(
        SnackBar(content: Text(_isEdit ? 'Student updated' : 'Student added')),
      );
    } catch (_) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Could not save right now. Please try again.'),
        ),
      );
    }
  }

  // ---------- UI ----------
  @override
  Widget build(BuildContext context) {
    ImageProvider? photoImage;
    if (_photo != null) {
      try {
        photoImage = MemoryImage(base64Decode(_photo!));
      } catch (_) {
        photoImage = null;
      }
    }

    return Scaffold(
      appBar: AppBar(title: Text(_isEdit ? 'Edit student' : 'Add student')),
      body: SafeArea(
        child: ResponsiveCenter(
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Center(
                  child: GestureDetector(
                    onTap: _showPhotoOptions,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: photoImage,
                      child: photoImage == null
                          ? const Icon(Icons.add_a_photo, size: 32)
                          : null,
                    ),
                  ),
                ),
                Center(
                  child: TextButton(
                    onPressed: _showPhotoOptions,
                    child: Text(_photo == null ? 'Add photo' : 'Change photo'),
                  ),
                ),
                const SizedBox(height: 8),
                AppTextField(
                  controller: _nameController,
                  label: 'Full name',
                  icon: Icons.person,
                  textInputAction: TextInputAction.next,
                  validator: Validators.name,
                ),
                AppTextField(
                  controller: _rollController,
                  label: 'Roll number',
                  icon: Icons.badge,
                  textInputAction: TextInputAction.next,
                  validator: Validators.rollNo,
                ),
                buildLabel('Department'),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: kDepartments.map((d) {
                    return ChoiceChip(
                      label: Text(d),
                      selected: _department == d,
                      onSelected: (_) => setState(() {
                        _department = d;
                        _departmentError = null;
                      }),
                    );
                  }).toList(),
                ),
                if (_departmentError != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      _departmentError!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                        fontSize: 12,
                      ),
                    ),
                  ),
                const SizedBox(height: 16),
                buildLabel('Year'),
                SegmentedButton<int>(
                  segments: const [
                    ButtonSegment(value: 1, label: Text('1st')),
                    ButtonSegment(value: 2, label: Text('2nd')),
                    ButtonSegment(value: 3, label: Text('3rd')),
                    ButtonSegment(value: 4, label: Text('4th')),
                  ],
                  selected: {_year},
                  onSelectionChanged: (selection) {
                    setState(() => _year = selection.first);
                  },
                ),
                const SizedBox(height: 20),
                AppTextField(
                  controller: _emailController,
                  label: 'Email',
                  icon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: Validators.email,
                ),
                AppTextField(
                  controller: _phoneController,
                  label: 'Phone number',
                  icon: Icons.phone,
                  keyboardType: TextInputType.phone,
                  formatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  validator: Validators.phone,
                ),
                const SizedBox(height: 6),
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
                        : Text(_isEdit ? 'Save changes' : 'Add student'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }
}
