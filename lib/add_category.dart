import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_dashboard/controller/admin/admin_bloc.dart';
import 'package:store_dashboard/image_picker.dart';

class AddCategoryPage extends StatefulWidget {
  const AddCategoryPage({super.key});

  @override
  State<AddCategoryPage> createState() => _AddCategoryPageState();
}

class _AddCategoryPageState extends State<AddCategoryPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  File? _selectedImage;
  bool _isLoading = false;

  void _submitCategory() {
    if (_formKey.currentState!.validate() && _selectedImage != null) {
      setState(() {
        _isLoading = true; // show loading
      });

      context.read<AdminBloc>().add(
        AddCategoryEvent(title: _nameController.text, image: _selectedImage!),
      );
    } else if (_selectedImage == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select an image')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AdminBloc, AdminState>(
      listener: (context, state) async {
        if (state is AddCategorySuccess) {
          setState(() {
            _isLoading = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Category added successfully!')),
          );

          // Pop after a short delay so the user sees the SnackBar
          await Future.delayed(const Duration(milliseconds: 500));
          Navigator.pop(context, true); // return true to indicate success
        } else if (state is AddCategoryError) {
          setState(() {
            _isLoading = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error adding category')),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Add Category')),
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Category Name',
                      ),
                      validator: (value) =>
                          value!.isEmpty ? 'Please enter Category name' : null,
                    ),
                    const SizedBox(height: 10),
                    // ImagePicker(
                    //   onImageSelected: (image) {
                    //     setState(() {
                    //       _selectedImage = image;
                    //     });
                    //   },
                    // ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.save),
                      label: const Text('Submit Category'),
                      onPressed: _isLoading ? null : _submitCategory,
                    ),
                  ],
                ),
              ),
            ),

            // Loading overlay
            if (_isLoading)
              Container(
                color: Colors.black.withOpacity(0.4),
                child: const Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      ),
    );
  }
}
