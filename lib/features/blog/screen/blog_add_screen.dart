import 'dart:io';
import 'package:flutter/material.dart';
import 'package:foodieland/features/blog/blog_repository/blog_repo_function.dart';
import 'package:foodieland/features/blog/widgets/cutom_blog_field.dart';
import 'package:foodieland/features/common/ui/widgets/recent_recipe_card.dart';
import 'package:foodieland/features/home/ui/controllers/random_recipes_controller.dart';
import 'package:foodieland/features/recipe_section/ui/screens/recipe_details_screen.dart';
import 'package:foodieland/utils/app_strings/app_strings.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../utils/app_colors/app_colors.dart';

class BlogPostScreen extends StatefulWidget {
  static final String routeName = '/blog-post';

  const BlogPostScreen({super.key});

  @override
  State<BlogPostScreen> createState() => _BlogPostScreenState();
}

class _BlogPostScreenState extends State<BlogPostScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for recipe details
  final TextEditingController blogTitleController = TextEditingController();
  final TextEditingController blogDescriptionController =
      TextEditingController();
  final TextEditingController blogSubTitleController = TextEditingController();

  // Image picker
  XFile? selectedImage;

  // Pick image
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        selectedImage = image;
      });
    }
  }

  final BlogRepository repository = BlogRepository(
    supabase: Supabase.instance.client,
  );

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.lightGray,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Back button and Title
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.arrow_back_ios),
                      ),
                      SizedBox(width: screenWidth * 0.08),
                      Text(
                        AppStrings.postBlogAndArticle,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  // SizedBox(height: size.height * 0.005),
                  // Text("Let's create a new blog or article!"),
                  SizedBox(height: size.height * 0.04),
                  // Blog Image Section with Add Button
                  GestureDetector(
                    onTap: _pickImage,
                    child:
                        selectedImage == null
                            ? Icon(
                              Icons.add_a_photo,
                              size: 80,
                              color: AppColors.black,
                            )
                            : Image.file(
                              File(selectedImage!.path),
                              fit: BoxFit.cover,
                              height: 200,
                              width: double.infinity,
                            ),
                  ),

                  SizedBox(height: size.height * 0.03),

                  // Blog Details Form
                  CustomBlogField(
                    blogController: blogTitleController,
                    title: 'Title',
                    fontSize: 14,
                  ),
                  const SizedBox(height: 10),
                  CustomBlogField(
                    blogController: blogSubTitleController,
                    title: 'Subtitle',
                    fontSize: 14,
                  ),
                  const SizedBox(height: 10),
                  CustomBlogField(
                    blogController: blogDescriptionController,
                    title: 'Description',
                    fontSize: 14,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await repository.saveBlogToSupabase(
                          context,
                          blogTitleController.text.trim(),
                          blogSubTitleController.text.trim(),
                          blogDescriptionController.text.trim(),
                          selectedImage != null
                              ? File(selectedImage!.path)
                              : null,
                        );

                        // field clear
                        blogTitleController.clear();
                        blogDescriptionController.clear();
                        blogSubTitleController.clear();
                        setState(() {
                          selectedImage = null;
                        });
                      }
                    },
                    child: const Text('Submit'),
                  ),

                  SizedBox(height: size.height * 0.03),

                  // Optional: Display recent recipes section
                  Row(
                    children: [
                      Text(
                        "Recent Blog & Article",
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: screenWidth * 0.04,
                          overflow: TextOverflow.ellipsis,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 210,
                    child: GetBuilder<RandomRecipesController>(
                      builder: (controller) {
                        return Visibility(
                          visible: controller.isProgress == false,
                          replacement: Center(
                            child: CircularProgressIndicator(),
                          ),
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
        ),
      ),
    );
  }
}
