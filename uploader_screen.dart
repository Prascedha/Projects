// lib/screens/uploader_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/certificate.dart'; // Import Certificate model
import 'package:provider/provider.dart';
import 'package:flutter_application_1/providers/app_state_provider.dart';
import 'package:intl/intl.dart'; // For date formatting

class UploaderScreen extends StatefulWidget {
  const UploaderScreen({super.key});

  @override
  State<UploaderScreen> createState() => _UploaderScreenState();
}

class _UploaderScreenState extends State<UploaderScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _issuerController = TextEditingController();
  final TextEditingController _issueDateController = TextEditingController();
  final TextEditingController _imageUrlController =
      TextEditingController(); // Keep this for the URL input

  DateTime? _selectedIssueDate;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _issuerController.dispose();
    _issueDateController.dispose();
    _imageUrlController.dispose(); // Dispose of image URL controller
    super.dispose();
  }

  Future<void> _selectIssueDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedIssueDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedIssueDate) {
      setState(() {
        _selectedIssueDate = picked;
        _issueDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  void _submitCertificate() {
    if (_formKey.currentState!.validate()) {
      final newCertificate = Certificate(
        id: DateTime.now()
            .millisecondsSinceEpoch
            .toString(), // Simple unique ID
        title: _titleController.text,
        description: _descriptionController.text,
        issuer: _issuerController.text,
        issueDate: _selectedIssueDate!,
        imageUrl: _imageUrlController.text
            .trim(), // Get URL from controller, trim whitespace
        isPublic: true, // Default to public for new uploads
      );

      Provider.of<AppStateProvider>(context, listen: false)
          .addCertificate(newCertificate);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Certificate Uploaded Successfully!')),
      );

      // Clear fields after submission
      _titleController.clear();
      _descriptionController.clear();
      _issuerController.clear();
      _issueDateController.clear();
      _imageUrlController.clear(); // Clear image URL field
      _selectedIssueDate = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Certificate Uploader'),
        centerTitle: true,
        automaticallyImplyLeading:
            false, // Prevents back button on main screens
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              // TODO: Navigate to profile or user settings
            },
          ),
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications),
                onPressed: () {
                  // TODO: Handle notifications
                },
              ),
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 12,
                    minHeight: 12,
                  ),
                  child: const Text(
                    '1', // Example notification count
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            ],
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _issuerController,
                decoration: const InputDecoration(
                  labelText: 'Issuer',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the issuer';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _issueDateController,
                decoration: InputDecoration(
                  labelText: 'Issue Date',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () => _selectIssueDate(context),
                  ),
                ),
                readOnly: true, // Make it read-only so date picker is used
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select an issue date';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              // Image URL input field
              TextFormField(
                controller: _imageUrlController, // This is your image URL input
                decoration: InputDecoration(
                  labelText: 'Image URL (Optional)',
                  border: const OutlineInputBorder(),
                  suffixIcon: ElevatedButton(
                    onPressed: () {
                      // This is the "Store" button from your image
                      // For now, it just shows a snackbar.
                      // In a real app, you'd implement logic to validate/process the URL.
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text(
                                'URL validation/storage logic would go here')),
                      );
                    },
                    child: const Text('Store'),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              // "Add relevant image" section for local file picking
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Add relevant image (from gallery/camera)',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.photo_library),
                      onPressed: () {
                        // TODO: Implement actual image picking functionality here
                        // For now, it just shows a snackbar.
                        // You'd use a package like 'image_picker' for this.
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content:
                                  Text('Image picking logic would go here')),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: _submitCertificate,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Upload Certificate',
                      style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
