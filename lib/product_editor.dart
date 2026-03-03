import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:store_dashboard/add_product.dart';
import 'package:store_dashboard/controller/admin/admin_bloc.dart';
import 'package:store_dashboard/edit_product.dart';

import 'package:store_dashboard/utils/gen/app_strings.dart';

class ProductEditor extends StatefulWidget {
  const ProductEditor({super.key});

  @override
  State<ProductEditor> createState() => _ProductEditorState();
}

class _ProductEditorState extends State<ProductEditor> {
  void _deleteProduct(int productId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppStrings.confirmDelete),
        content: Text(AppStrings.areYouSureDeleteProduct),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(AppStrings.delete),
          ),
        ],
      ),
    );

    if (confirm == true) {
      context.read<AdminBloc>().add(DeleteProductEvent(id: productId));

      // Reload after deletion
      await Future.delayed(const Duration(milliseconds: 500));
      setState(() {});
    }
  }

  void _goToAddProductPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AddProductPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AdminBloc.fetchProducts(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final products = snapshot.data!;

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            ElevatedButton.icon(
              icon: const FaIcon(FontAwesomeIcons.plus),
              label: Text(AppStrings.goToAddProduct),
              onPressed: _goToAddProductPage,
            ),
            const SizedBox(height: 20),
            Text(
              AppStrings.productList,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ...products.asMap().entries.map((entry) {
              final product = entry.value;
              // Add a local favorite state
              bool isFavorite = product['is_favorite'] ?? false;

              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: product['image_url'] != null
                        ? NetworkImage(product['image_url'])
                        : null,
                    child: product['image_url'] == null
                        ? const FaIcon(
                            FontAwesomeIcons.image,
                            color: Colors.grey,
                          )
                        : null,
                  ),
                  title: Text(product['title']),
                  subtitle: Text(
                    '${product['category']} - \$${product['price']}',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Favorite toggle
                      IconButton(
                        icon: FaIcon(
                          isFavorite
                              ? FontAwesomeIcons.solidHeart
                              : FontAwesomeIcons.heart,
                          color: isFavorite ? Colors.red : Colors.grey,
                          size: 18,
                        ),
                        onPressed: () {
                          setState(() {
                            isFavorite = !isFavorite;
                          });
                          context.read<AdminBloc>().add(
                            ToggleFavoriteEvent(
                              productId: product['id'],
                              isFavorite: isFavorite,
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const FaIcon(
                          FontAwesomeIcons.penToSquare,
                          color: Colors.orange,
                          size: 18,
                        ),
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                EditProductPage(productId: product['id']),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const FaIcon(
                          FontAwesomeIcons.trashCan,
                          color: Colors.red,
                          size: 18,
                        ),
                        onPressed: () => _deleteProduct(product['id']),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        );
      },
    );
  }
}
