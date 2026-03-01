import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_dashboard/controller/admin/admin_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditCategory extends StatefulWidget {
  final int productId;

  const EditCategory({super.key, required this.productId});

  @override
  State<EditCategory> createState() => _EditCategoryPageState();
}

class _EditCategoryPageState extends State<EditCategory> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  bool _isControllersInitialized = false;
  String? _selectedCategory;
  void _saveChanges() {
    BlocProvider.of<AdminBloc>(context).add(
      EditProductEvent(
        title: _titleController.text,
        price: int.parse(_priceController.text),
        description: _descriptionController.text,
        catigory: _selectedCategory as String,
        id: widget.productId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AdminBloc.fetchproduct(widget.productId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (!_isControllersInitialized) {
          final product = snapshot.data!.first;
          _titleController.text = product['title'] ?? '';
          _priceController.text = product['price']?.toString() ?? '';
          _descriptionController.text = product['description'] ?? '';
          _selectedCategory = product['category'];
          _isControllersInitialized = true;
        }

        return Scaffold(
          appBar: AppBar(title: const Text('Edit Product')),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _priceController,
                  decoration: const InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                  maxLines: 3,
                ),
                const SizedBox(height: 20),
                StreamBuilder<List<Map<String, dynamic>>>(
                  stream: Supabase.instance.client
                      .from('categories')
                      .select()
                      .asStream()
                      .map((event) => List<Map<String, dynamic>>.from(event)),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Text('No categories found');
                    }

                    final categories = snapshot.data!;
                    return DropdownButtonFormField<String>(
                      value: _selectedCategory,
                      items: categories
                          .map(
                            (cat) => DropdownMenuItem<String>(
                              value: cat['title'] as String,
                              child: Text(cat['title'] as String),
                            ),
                          )
                          .toList(),
                      onChanged: (val) =>
                          setState(() => _selectedCategory = val),
                      decoration: const InputDecoration(labelText: 'Category'),
                      validator: (value) =>
                          value == null ? 'Please select a category' : null,
                    );
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  icon: const Icon(Icons.save),
                  label: const Text('Save'),
                  onPressed: _saveChanges,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
