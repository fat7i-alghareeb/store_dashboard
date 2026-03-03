import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:store_dashboard/controller/admin/admin_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:store_dashboard/utils/gen/app_strings.dart';

class EditProductPage extends StatefulWidget {
  final int productId;

  const EditProductPage({super.key, required this.productId});

  @override
  State<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  bool _isControllersInitialized = false;
  String? _selectedCategory;
  void _saveChanges() async {
    BlocProvider.of<AdminBloc>(context).add(
      EditProductEvent(
        title: _titleController.text,
        price: int.parse(_priceController.text),
        description: _descriptionController.text,
        catigory: _selectedCategory as String,
        id: widget.productId,
      ),
    );

    // Wait a short time for the update to complete
    await Future.delayed(const Duration(milliseconds: 500));

    // Pop and return true to indicate success
    Navigator.pop(context, true);
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
          appBar: AppBar(title: Text(AppStrings.editProduct)),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(labelText: AppStrings.fieldTitle),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _priceController,
                  decoration: InputDecoration(labelText: AppStrings.price),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: AppStrings.description,
                  ),
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
                      return Text(AppStrings.noCategoriesFound);
                    }

                    final categories = snapshot.data!;
                    return DropdownButtonFormField<String>(
                      initialValue: _selectedCategory,
                      items: categories
                          .map(
                            (cat) => DropdownMenuItem<String>(
                              value: cat['category_title'] as String,
                              child: Text(cat['category_title'] as String),
                            ),
                          )
                          .toList(),
                      onChanged: (val) =>
                          setState(() => _selectedCategory = val),
                      decoration: InputDecoration(
                        labelText: AppStrings.category,
                      ),
                      validator: (value) => value == null
                          ? AppStrings.pleaseSelectACategory
                          : null,
                    );
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  icon: const FaIcon(FontAwesomeIcons.floppyDisk),
                  label: Text(AppStrings.save),
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
