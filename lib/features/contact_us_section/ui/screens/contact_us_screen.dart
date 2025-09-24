import 'package:flutter/material.dart';
import 'package:foodieland/features/home/ui/controllers/random_recipes_controller.dart';
import 'package:get/get.dart';

import '../../../../utils/app_colors/app_colors.dart';
import '../../../../utils/app_strings/app_strings.dart';
import '../../../../components/action_button/action_button.dart';
import '../../../../components/custom_text_field/custom_text_field.dart';
import '../../../../components/input_card_container/input_card_container.dart';
import '../../../common/ui/widgets/recent_recipe_card.dart';
import '../../../recipe_section/ui/screens/recipe_details_screen.dart';
import '../controller/contact_us_controller.dart';

class ContactUsScreen extends StatefulWidget {
  static final String routeName = '/contact-us';
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  final ContactUsController _contactUsController =
      Get.find<ContactUsController>();
  final _formKey = GlobalKey<FormState>();
  final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
  final phoneRegex = RegExp(r'^\+?[\d\s\-]{7,15}$');
  // Form submission logic (without validation)
  // Updated submit handler
  Future<void> handleSubmit() async {
    if (_formKey.currentState?.validate() ?? false) {
      bool success = await _contactUsController.submitContactForm();
      if (success) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(AppStrings.messageSent)));
      }
      // else error is shown in controller via Get.snackbar already
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
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
                  SizedBox(height: size.height * 0.02),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.arrow_back_ios),
                          ),
                          SizedBox(width: screenWidth * 0.15),
                          Text(
                            AppStrings.contactUs,
                            style: textTheme.bodyLarge?.copyWith(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * 0.04),
                  InputCardContainer(
                    doubleHeightIndexes: [3],
                    minHeight: 360,
                    children: [
                      CustomTextField(
                        controller: _contactUsController.nameController,
                        labelText: AppStrings.name,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Name cannot be empty';
                          } else if (value.trim().length <= 2) {
                            return 'Name must be at least 3 characters';
                          }
                          return null;
                        },
                      ),
                      CustomTextField(
                        controller: _contactUsController.emailController,
                        labelText: AppStrings.emailAddress,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Email cannot be empty';
                          } else if (!emailRegex.hasMatch(value.trim())) {
                            return 'Enter a valid email';
                          }
                          return null;
                        },
                      ),
                      CustomTextField(
                        controller: _contactUsController.phoneController,
                        labelText: AppStrings.phoneNumber,
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Phone number cannot be empty';
                          } else if (!phoneRegex.hasMatch(value.trim())) {
                            return 'Enter a valid phone number';
                          }
                          return null;
                        },
                      ),
                      CustomTextField(
                        textFieldLines: 2,
                        controller: _contactUsController.messageController,
                        labelText: AppStrings.message,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Message cannot be empty';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * 0.02),
                  Obx(
                    () => ActionButton(
                      height: 45,
                      backgroundColor: AppColors.black,
                      title: AppStrings.submitButton,
                      onPressed:
                          _contactUsController.isLoading.value
                              ? null
                              : handleSubmit,
                    ),
                  ),

                  SizedBox(height: size.height * 0.03),
                  Row(
                    children: [
                      Text(
                        AppStrings.recentRecipes,
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
                  SizedBox(height: size.height * 0.02),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
