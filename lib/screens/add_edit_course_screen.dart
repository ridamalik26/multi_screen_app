import 'package:flutter/material.dart';
import '../models/course_model.dart';
import '../services/api_service.dart';


class AddEditCourseScreen extends StatefulWidget {
  const AddEditCourseScreen({super.key});

  @override
  State<AddEditCourseScreen> createState() => _AddEditCourseScreenState();
}

class _AddEditCourseScreenState extends State<AddEditCourseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  final ApiService _apiService = ApiService();
  bool _isLoading = false;
  Course? _existingCourse;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _existingCourse = ModalRoute.of(context)?.settings.arguments as Course?;
    if (_existingCourse != null) {
      _titleController.text = _existingCourse!.title;
      _bodyController.text = _existingCourse!.body;
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() { _isLoading = true; });
    try {
      Course result;
      if (_existingCourse != null) {
        result = await _apiService.updateCourse(
          _existingCourse!.id,
          _titleController.text,
          _bodyController.text,
        );
      } else {
        result = await _apiService.addCourse(
          _titleController.text,
          _bodyController.text,
        );
      }
      if (!mounted) return;
      Navigator.pop(context, result);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    }
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = _existingCourse != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Course Edit Karo' : 'Naya Course Add Karo'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
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
                  labelText: 'Course Title',
                  border: OutlineInputBorder(),
                ),
                validator: (val) => val!.isEmpty ? 'Title likho' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _bodyController,
                decoration: const InputDecoration(
                  labelText: 'Course Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
                validator: (val) => val!.isEmpty ? 'Description likho' : null,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(isEditing ? 'Update Karo' : 'Add Karo'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}