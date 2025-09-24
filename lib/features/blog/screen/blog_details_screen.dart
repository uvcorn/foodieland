import 'package:flutter/material.dart';
import 'package:foodieland/features/blog/model/blog_model.dart';
import 'package:foodieland/features/blog/widgets/author_img.dart';
import 'package:foodieland/features/common/ui/widgets/recent_recipe_card.dart';
import 'package:foodieland/features/home/ui/controllers/random_recipes_controller.dart';
import 'package:foodieland/features/recipe_section/ui/screens/recipe_details_screen.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class BlogDetailsScreen extends StatelessWidget {
  final Blog blog;

  const BlogDetailsScreen({super.key, required this.blog});

  static final String routeName = '/blog-details-screen';

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('dd MMM yyyy').format(blog.date);

    return Scaffold(
      appBar: AppBar(title: const Text('Blog Details')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Title
              Text(
                blog.title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              /// Author & Date
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      AuthorImg(authorImg: blog.authorImg ?? ''),

                      const SizedBox(width: 8),
                      Text("By ${blog.author}"),
                    ],
                  ),
                  Text(
                    formattedDate,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),

              const SizedBox(height: 16),
              Text(
                blog.subtitle,
                style: const TextStyle(fontSize: 16, color: Colors.black54),
              ),

              const SizedBox(height: 16),

              /// Blog Image
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child:
                    blog.image != null && blog.image!.isNotEmpty
                        ? Image.network(blog.image!, fit: BoxFit.cover)
                        : Container(
                          height: 200,
                          color: Colors.grey[300],
                          child: const Icon(
                            Icons.image,
                            size: 40,
                            color: Colors.grey,
                          ),
                        ),
              ),

              const SizedBox(height: 20),

              /// Blog Content
              // Content Blocks
              Text(
                blog.description ?? '',
                style: const TextStyle(fontSize: 14, height: 1.5),
              ),

              const SizedBox(height: 20),

              /// Example quote section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  "“Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur ac ultrices odio.”",
                  style: TextStyle(fontStyle: FontStyle.italic, fontSize: 16),
                ),
              ),

              const SizedBox(height: 20),

              /// Example Newsletter Subscribe
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.lightBlue.shade50,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    const Text(
                      "Deliciousness to your inbox",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      decoration: InputDecoration(
                        hintText: "Enter your email",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.send),
                          onPressed: () {},
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              /// Related Recipes Section
              const Text(
                "Check out the delicious recipe",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 18),
              SizedBox(
                height: 210,
                child: GetBuilder<RandomRecipesController>(
                  builder: (controller) {
                    return Visibility(
                      visible: controller.isProgress == false,
                      replacement: Center(child: CircularProgressIndicator()),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: controller.recipesFirstList.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          final recipe = controller.recipesFirstList[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 5.0,
                            ),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  RecipeDetailsScreen.routeName,
                                  arguments: recipe.id,
                                );
                              },
                              child: RecentRecipeCard(
                                imageLink: recipe.imageUrl,
                                title: recipe.title,
                                cookingTime: '${recipe.cookingTime} Minute',
                                categoriesName: recipe.category,
                                recipeId: recipe.id,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
