import 'package:flutter/material.dart';
import 'package:foodieland/features/auth/screens/forget_password_screen.dart';
import 'package:foodieland/features/auth/screens/reset_password_screen.dart';
import 'package:foodieland/features/auth/screens/sign_in_screen.dart';
import 'package:foodieland/features/auth/screens/sign_up_screen.dart';
import 'package:foodieland/features/blog/screen/blog_add_screen.dart';
import 'package:foodieland/features/blog/screen/blog_details_screen.dart';
import 'package:foodieland/features/auth/screens/user_profile_screen.dart';
import 'package:foodieland/features/blog/screen/blog_list_screen.dart';
import 'package:foodieland/features/categories/ui/screens/categories_items_list_screen.dart';
import 'package:foodieland/features/categories/ui/screens/categories_screen.dart';
import 'package:foodieland/features/contact_us_section/ui/screens/contact_us_screen.dart';
import 'package:foodieland/features/home/ui/screens/favorite_list_screen.dart';
import 'package:foodieland/features/home/ui/screens/home_screen.dart';
import 'package:foodieland/features/recipe_section/ui/screens/recipe_details_screen.dart';
import 'package:foodieland/features/home/ui/screens/recipes_screen.dart';
import '../features/blog/model/blog_model.dart';
import '../features/recipe_section/ui/screens/recipe_post_screen.dart';
import '../features/splash_screen/splash_screens.dart';

class AppRoutes {
  static Route<dynamic> routes(RouteSettings settings) {
    late Widget screenWidget;

    if (settings.name == HomeScreen.routeName) {
      screenWidget = HomeScreen();
    } else if (settings.name == SignInScreen.routeName) {
      screenWidget = SignInScreen();
    } else if (settings.name == SplashScreen.routeName) {
      screenWidget = SplashScreen();
    } else if (settings.name == SignUpScreen.routeName) {
      screenWidget = SignUpScreen();
    } else if (settings.name == ForgotPasswordScreen.routeName) {
      screenWidget = ForgotPasswordScreen();
    } else if (settings.name == ResetPasswordScreen.routeName) {
      screenWidget = ResetPasswordScreen();
    } else if (settings.name == RecipeDetailsScreen.routeName) {
      final String recipeId = settings.arguments as String;
      screenWidget = RecipeDetailsScreen(recipeId: recipeId);
    } else if (settings.name == ContactUsScreen.routeName) {
      screenWidget = ContactUsScreen();
    } else if (settings.name == UserProfileScreen.routeName) {
      screenWidget = UserProfileScreen();
    } else if (settings.name == RecipesScreen.routeName) {
      screenWidget = RecipesScreen();
    } else if (settings.name == CategoriesScreen.routeName) {
      screenWidget = CategoriesScreen();
    } else if (settings.name == BlogListPage.routeName) {
      screenWidget = BlogListPage();
    } else if (settings.name == FavoriteListScreen.routeName) {
      screenWidget = FavoriteListScreen();
    } else if (settings.name == CategoriesItemsListScreen.routeName) {
      final String categoryName = settings.arguments as String;
      screenWidget = CategoriesItemsListScreen(categoryName: categoryName);
    } else if (settings.name == RecipePostScreen.routeName) {
      screenWidget = RecipePostScreen();
    } else if (settings.name == BlogDetailsScreen.routeName) {
      screenWidget = BlogDetailsScreen(blog: Blog.fromMap({}));
    } else if (settings.name == BlogPostScreen.routeName) {
      screenWidget = BlogPostScreen();
    } else {
      screenWidget = const HomeScreen(); // Default route if no match
    }

    return MaterialPageRoute(builder: (context) => screenWidget);
  }
}
