import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_dashboard/controller/admin/admin_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:store_dashboard/utils/gen/app_strings.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String? _selectedCategory;
  File? _selectedImage;

  void _submitProduct() {
    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(AppStrings.productAdded),
          content: Text(AppStrings.productAddedSuccessfully),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);

                // إرسال البيانات إلى Bloc
                BlocProvider.of<AdminBloc>(context).add(
                  AddProductEvent(
                    title: _nameController.text,
                    description: _descriptionController.text,
                    price: int.parse(_priceController.text),
                    isSpecial: false,
                    image: _selectedImage!, // ملف الصورة
                    catigory: _selectedCategory!, // الفئة
                  ),
                );
              },
              child: Text(AppStrings.ok),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.addProduct)),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // اسم المنتج
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: AppStrings.productName),
                validator: (value) =>
                    value!.isEmpty ? AppStrings.pleaseEnterProductName : null,
              ),
              const SizedBox(height: 10),

              // السعر
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(labelText: AppStrings.price),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? AppStrings.pleaseEnterPrice : null,
              ),
              const SizedBox(height: 10),

              // الفئات من Supabase
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
                    onChanged: (val) => setState(() => _selectedCategory = val),
                    decoration: InputDecoration(labelText: AppStrings.category),
                    validator: (value) =>
                        value == null ? AppStrings.pleaseSelectACategory : null,
                  );
                },
              ),
              const SizedBox(height: 10),

              // الوصف
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: InputDecoration(labelText: AppStrings.description),
              ),
              const SizedBox(height: 20),

              // // اختيار صورة
              // ImagePicker(
              //   onImageSelected: (image) {
              //     setState(() {
              //       _selectedImage = image;
              //     });
              //   },
              // ),
              const SizedBox(height: 20),

              // زر الإرسال
              ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: Text(AppStrings.submitProduct),
                onPressed: _submitProduct,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
