// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:foodieland/features/categories/ui/screens/categories_item_card.dart';
import 'package:foodieland/features/categories/ui/screens/categories_items_list_screen.dart';
import 'package:foodieland/features/home/ui/controllers/category_controller.dart';
import 'package:get/get.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});
  static final String routeName = '/categories-screen';

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Categories")),
      body: GetBuilder<CategoryController>(
        builder: (controller) {
          return Visibility(
            visible: controller.isLoading == false,
            replacement: Center(child: CircularProgressIndicator()),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
              ),
              itemCount: controller.categories.length,
              itemBuilder: (context, index) {
                final item = controller.categories[index];
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: CategoriesItemCard(
                      imageLink: item.imageUrl,
                      title: item.categoryName,
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          CategoriesItemsListScreen.routeName,
                          arguments: item.categoryName,
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
