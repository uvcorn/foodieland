// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foodieland/components/snackbar_helper/snackbar_helper.dart';
import 'package:foodieland/features/common/ui/controllers/favorite_controller.dart';
import 'package:foodieland/features/home/ui/controllers/category_controller.dart';
import 'package:foodieland/features/home/ui/controllers/random_recipes_controller.dart';

import 'package:foodieland/features/home/ui/controllers/sliders_controller.dart';
import 'package:foodieland/features/home/ui/screens/recipes_screen.dart';
import 'package:foodieland/features/auth/screens/user_profile_screen.dart';
import 'package:foodieland/features/blog/screen/blog_list_screen.dart';
import 'package:foodieland/features/categories/ui/screens/categories_item_card.dart';
import 'package:foodieland/features/categories/ui/screens/categories_items_list_screen.dart';
import 'package:foodieland/features/categories/ui/screens/categories_screen.dart';
import 'package:foodieland/features/home/ui/screens/favorite_list_screen.dart';
import 'package:foodieland/utils/app_colors/app_colors.dart';
import 'package:foodieland/utils/app_icons/app_icons.dart';
import 'package:foodieland/utils/assets_path/assets_path.dart';
import 'package:foodieland/features/common/ui/widgets/network_image_with_error_image.dart';
import 'package:foodieland/features/common/ui/widgets/recipe_card.dart';
import 'package:foodieland/features/contact_us_section/ui/screens/contact_us_screen.dart';
import 'package:foodieland/features/home/ui/widgets/home_carousel_slider.dart';
import 'package:foodieland/features/auth/screens/sign_in_screen.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../blog/screen/blog_add_screen.dart';
import '../../../recipe_section/ui/screens/recipe_details_screen.dart';
import '../../../recipe_section/ui/screens/recipe_post_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static final String routeName = '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final RandomRecipesController _randomRecipesController =
      Get.find<RandomRecipesController>();

  Future<void> _logout() async {
    try {
      // Logout from Supabase and clear session
      await Supabase.instance.client.auth.signOut();
      final session = Supabase.instance.client.auth.currentSession;
      Get.find<FavoritesController>().clearFavorites();
      print(" Signed out! $session");

      Navigator.pop(context);
      setState(() {});
      SnackbarHelper.show(
        message: 'Signed out!',
        isSuccess: false,
        backgroundColor: AppColors.red,
        textColor: Colors.white,
      );
    } on AuthException catch (e) {
      // Handle sign-out error
      print('Error signing out: ${e.message}');
    } catch (e) {
      // Handle other potential errors
      print('An unexpected error occurred: $e');
    }
  }

  bool _showAccountOptions = false; // toggle state

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final user = Supabase.instance.client.auth.currentUser;
    return Scaffold(
      appBar: _buildAppBar(),
      drawer: _buildDrawer(user),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Column(
            children: [
              GetBuilder<SlidersController>(
                init: SlidersController(),
                builder: (controller) {
                  return Visibility(
                    visible: controller.isLoading.value == false,
                    replacement: const Center(
                      child: CircularProgressIndicator(),
                    ),
                    child: HomeCarouselSlider(sliders: controller.sliders),
                  );
                },
              ),
              const SizedBox(height: 20),
              buildCategoriesTitleSection(screenWidth),
              const SizedBox(height: 10),
              GetBuilder<CategoryController>(
                builder: (controller) {
                  return Visibility(
                    visible: controller.isLoading == false,
                    replacement: Center(child: CircularProgressIndicator()),
                    child: _getCategoryList(),
                  );
                },
              ),
              const SizedBox(height: 15),
              Center(
                child: Text(
                  "Simple and testy recipes",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: screenWidth * 0.05,
                  ),
                ),
              ),
              Text(
                "Lorem ipsum dolor sit amet, consectetuipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqut enim ad minim",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: screenWidth * 0.03,
                ),
              ),
              const SizedBox(height: 25),
              GetBuilder(
                init: _randomRecipesController,
                builder: (controller) {
                  return Visibility(
                    visible: controller.isProgress == false,
                    replacement: Center(child: CircularProgressIndicator()),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.recipesFirstList.length,
                      scrollDirection: Axis.vertical,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 5,
                        childAspectRatio: 0.9,
                      ),
                      itemBuilder: (context, index) {
                        final recipe = controller.recipesFirstList[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              RecipeDetailsScreen.routeName,
                              arguments: recipe.id,
                            );
                          },
                          child: RecipeCard(
                            imageLink: recipe.imageUrl,
                            title: recipe.title,
                            cookingTime: '${recipe.cookingTime} Minute',
                            categoriesName: recipe.category,
                            recipeId: recipe.id,
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, ContactUsScreen.routeName);
                },
                child: Image.asset(AssetsPath.chef),
              ),
              const SizedBox(height: 20),
              buildFoodieLandInstagramCard(screenWidth),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "Try this delicious recipe to make your day",
                      maxLines: 2,
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: screenWidth * 0.04,
                        overflow: TextOverflow.ellipsis,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "Lorem ipsum dolor sit amet, consectetuipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqut enim ad minim ",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: screenWidth * 0.02,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              GetBuilder(
                init: _randomRecipesController,
                builder: (controller) {
                  return Visibility(
                    visible: controller.isProgressSecond == false,
                    replacement: Center(child: CircularProgressIndicator()),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.recipesSecondList.length,
                      scrollDirection: Axis.vertical,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 5,
                        childAspectRatio: 0.9,
                      ),
                      itemBuilder: (context, index) {
                        final recipe = controller.recipesSecondList[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              RecipeDetailsScreen.routeName,
                              arguments: recipe.id,
                            );
                          },
                          child: RecipeCard(
                            imageLink: recipe.imageUrl,
                            title: recipe.title,
                            cookingTime: '${recipe.cookingTime} Minute',
                            categoriesName: recipe.category,
                            recipeId: recipe.id,
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: SpeedDial(
        icon: Icons.add,
        activeIcon: Icons.close,
        backgroundColor: AppColors.primary,
        spacing: 4,
        children: [
          SpeedDialChild(
            child: const Icon(Icons.restaurant, color: AppColors.white),
            // label: AppStrings.postRecipe,
            backgroundColor: AppColors.primary,
            onTap: () {
              if (user != null) {
                Navigator.pushNamed(context, RecipePostScreen.routeName);
              } else {
                showLoginPopup(
                  context,
                  "You need to log in to post a Recipe.\n Please login to continue. ",
                );
              }
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.article_rounded, color: AppColors.white),
            // label: AppStrings.postBlog,
            backgroundColor: AppColors.primary,
            onTap: () {
              if (user != null) {
                Navigator.pushNamed(context, BlogPostScreen.routeName);
              } else {
                showLoginPopup(
                  context,
                  "You need to log in to post a blog.\n Please login to continue. ",
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget buildFoodieLandInstagramCard(double screenWidth) {
    return Container(
      color: AppColors.themeColor.withOpacity(0.06),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          children: [
            Text(
              "Check out @foodieland on Instagram",
              style: TextStyle(
                fontSize: screenWidth * 0.04,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Lorem ipsum dolor sit amet, consectetuipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqut enim ad minim ",
              style: TextStyle(
                fontSize: screenWidth * 0.025,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                buildInstagramImage(
                  screenWidth,
                  imageLink: "https://i.postimg.cc/JDvn62jb/Post.png",
                ),
                buildInstagramImage(
                  screenWidth,
                  imageLink: "https://i.postimg.cc/YGh0xHLr/Post-1.png",
                ),
                buildInstagramImage(
                  screenWidth,
                  imageLink: "https://i.postimg.cc/sBfvvSVZ/Post-2.png",
                ),
              ],
            ),
            const SizedBox(height: 30),
            GestureDetector(
              onTap: () {
                _onTapGotoInstagram();
              },
              child: Image.asset(
                AssetsPath.visitOurInstagram,
                width: screenWidth * 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildInstagramImage(double screenWidth, {required String imageLink}) {
    return NetworkImageWithErrorImage(
      imageLink: imageLink,
      errorAssets: AssetsPath.squarePhoto,
      width: screenWidth * 0.2,
    );
  }

  Widget buildCategoriesTitleSection(double width) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Categories",
          style: TextStyle(fontSize: width * 0.05, fontWeight: FontWeight.w700),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, CategoriesScreen.routeName);
          },
          child: Text(
            "View All Categories",
            style: TextStyle(fontSize: width * 0.03),
          ),
        ),
      ],
    );
  }

  Widget _getCategoryList() {
    return SizedBox(
      height: 100,
      child: GetBuilder<CategoryController>(
        builder: (controller) {
          return ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: controller.categories.length,
            itemBuilder: (context, index) {
              final item = controller.categories[index];
              return CategoriesItemCard(
                imageLink: item.imageUrl,
                title: item.categoryName,
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    CategoriesItemsListScreen.routeName,
                    arguments: item.categoryName,
                  );
                },
              );
            },
            separatorBuilder: (context, index) => const SizedBox(width: 8),
          );
        },
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: SvgPicture.asset(AppIcons.logo),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.pushNamed(context, FavoriteListScreen.routeName);
          },
          icon: Icon(Icons.favorite, color: Colors.red),
        ),
        const SizedBox(width: 10),
      ],
    );
  }

  Drawer _buildDrawer(User? user) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.6,
      child: Column(
        children: [
          // 🔹 No DrawerHeader here, just a flexible top section
          Material(
            color: Colors.transparent,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (user == null)
                  SizedBox(
                    height: 180,
                    width: double.infinity,
                    child: Container(
                      margin: EdgeInsets.only(bottom: 8.0),
                      decoration: BoxDecoration(
                        color: Colors.teal.withOpacity(0.6),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        border: Border.all(color: Colors.grey, width: 2),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                SignInScreen.routeName,
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 30,
                              ),
                              child: Text("Login / Signup "),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                if (user != null)
                  UserAccountsDrawerHeader(
                    onDetailsPressed: () {
                      setState(() {
                        _showAccountOptions = !_showAccountOptions;
                      });
                    },
                    decoration: BoxDecoration(
                      color: Colors.teal.withOpacity(0.6),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      border: Border.all(color: Colors.grey, width: 2),
                    ),
                    currentAccountPicture: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          UserProfileScreen.routeName,
                        );
                      },
                      child: CircleAvatar(
                        backgroundImage:
                            (user.userMetadata?['avatar_url'] != null &&
                                    user.userMetadata!['avatar_url']
                                        .toString()
                                        .isNotEmpty)
                                ? NetworkImage(user.userMetadata!['avatar_url'])
                                : const AssetImage(AssetsPath.avatarProfileUser)
                                    as ImageProvider,
                      ),
                    ),
                    accountName: Text(
                      "${user.userMetadata!['full_name'] ?? "Unknown"}",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                    accountEmail: Text(
                      user.userMetadata!['email'] ?? "",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                if (user != null)
                  if (_showAccountOptions)
                    Container(
                      color: Colors.grey.shade200,
                      child: Column(
                        children: [
                          ListTile(
                            leading: Icon(Icons.logout),
                            title: Text("Logout"),
                            onTap: () {
                              _logout();
                            },
                          ),
                        ],
                      ),
                    ),
              ],
            ),
          ),

          // 👉 Drawer items (now appear right after header, no extra gap)
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero, // removes default ListView padding
              children: [
                ListTile(
                  onTap: () {
                    Navigator.pushNamed(context, RecipesScreen.routeName);
                  },
                  leading: Icon(Icons.fastfood_outlined),
                  title: drawerText("Recipes"),
                ),
                ListTile(
                  onTap: () {
                    Navigator.pushNamed(context, BlogListPage.routeName);
                  },
                  leading: Icon(Icons.newspaper_outlined),
                  title: drawerText("Blog"),
                ),
                ListTile(
                  onTap: () {
                    Navigator.pushNamed(context, ContactUsScreen.routeName);
                  },
                  leading: Icon(Icons.message_outlined),
                  title: drawerText("Contact Us"),
                ),
                // ListTile(
                //   onTap: () {},
                //   leading: Icon(Icons.person_outline),
                //   title: drawerText("About Us"),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onTapGotoInstagram() async {
    final Uri _url = Uri.parse('https://www.instagram.com/');
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  void showLoginPopup(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "Login Required",
            style: TextStyle(
              color: Colors.black,
              fontFamily: "Poppins",
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          content: Text(
            message,
            style: TextStyle(
              color: Colors.black,
              fontFamily: "Poppins",
              fontSize: 16,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // cancel
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // popup বন্ধ
                Navigator.pushNamed(context, '/sign-in');
              },
              child: const Text("Login"),
            ),
          ],
        );
      },
    );
  }

  Text drawerText(String text) =>
      Text(text, style: Theme.of(context).textTheme.bodyMedium);
}
