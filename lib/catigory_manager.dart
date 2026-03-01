import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_dashboard/add_category.dart';
import 'package:store_dashboard/controller/admin/admin_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:store_dashboard/utils/gen/app_strings.dart';

class CategoryManager extends StatefulWidget {
  const CategoryManager({super.key});

  @override
  State<CategoryManager> createState() => _CategoryManagerState();
}

class _CategoryManagerState extends State<CategoryManager> {
  final _client = Supabase.instance.client;
  List<Map<String, dynamic>> _categories = [];
  bool _loading = true;
  bool _deleting = false;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    setState(() => _loading = true);

    final response = await _client
        .from('categories')
        .select()
        .order('created_at', ascending: false);

    setState(() {
      _categories = List<Map<String, dynamic>>.from(response as List);
      _loading = false;
    });
  }

  Future<void> _onAddCategory() async {
    await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const AddCategoryPage()));
    await _loadCategories(); // Refresh after adding
  }

  void _onDeleteCategory(int id) {
    setState(() => _deleting = true);
    context.read<AdminBloc>().add(DeleteCategoryEvent(id: id));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AdminBloc, AdminState>(
      listener: (context, state) async {
        if (state is DeleteCategorySuccess) {
          // ✅ Wait until deletion completes
          await _loadCategories();
          setState(() => _deleting = false);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppStrings.categoryDeletedSuccessfully)),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text(AppStrings.categoryManager)),
        body: Stack(
          children: [
            _loading
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: _loadCategories,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _categories.length + 1,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: ElevatedButton.icon(
                              icon: const Icon(Icons.add),
                              label: Text(AppStrings.addCategory),
                              onPressed: _onAddCategory,
                            ),
                          );
                        }

                        final category = _categories[index - 1];

                        return Card(
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(category['image']),
                            ),
                            title: Text(category['category_title']),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {},
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () async {
                                    final confirm = await showDialog<bool>(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                        title: Text(AppStrings.confirmDelete),
                                        content: Text(
                                          AppStrings.areYouSureDeleteCategory,
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, false),
                                            child: Text(AppStrings.cancel),
                                          ),
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, true),
                                            child: Text(AppStrings.delete),
                                          ),
                                        ],
                                      ),
                                    );

                                    if (confirm == true) {
                                      _onDeleteCategory(category['id']);
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

            // 🔄 Show loading overlay when deleting
            if (_deleting)
              Container(
                color: Colors.black54,
                child: const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
