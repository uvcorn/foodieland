<div align="center">

![Foodieland Logo](https://github.com/raselahmedadnan/foodieland/blob/master/assets/images/foodieland.png)

  
# 🥘 Foodieland  
** Taste the World, Anytime. **

![Dart](https://img.shields.io/badge/Dart-3.0-blue?logo=dart&logoColor=white)
![Flutter](https://img.shields.io/badge/Flutter-3.10-blue?logo=flutter&logoColor=white)
![GetX](https://img.shields.io/badge/GetX-State_Management-purple?logo=getx&logoColor=white)
![Supabase Storage](https://img.shields.io/badge/Supabase-Storage-brightgreen?logo=supabase&logoColor=white)
![Android Studio](https://img.shields.io/badge/Android_Studio-Giraffe-green?logo=androidstudio&logoColor=white)


</div>

<table>
<tr>
<td>


## 🚀 Getting Started  

Follow these steps to set up the project:  

 1️⃣.🚀**Clone the Repository** 
 
 2️⃣.🚀**Must be Add a .env File with api and url for App Load and also add env on pubspec.yml under asset** ⭐⭐⭐
 
 3️⃣.🚀**Flutter Pub Get** 
 
 4️⃣.🚀**Flutter Run** 




## 📖 About Foodieland

Foodieland — your one-stop food & recipe destination!
Discover a seamless cooking and food experience with Foodieland, where you can explore a wide range of delicious recipes, cooking tips, blogs, and food inspiration — all in one place.

✅ Easy to explore

✅ Chef-inspired recipes

✅ Fresh food ideas guaranteed

✅ Save & share your favorites

✅ Exclusive tips and food stories

With Foodieland, food is not just cooking, it’s an experience. Save your time, enjoy your meals — Foodieland is here to make everyday cooking effortless and delightful!







✅ Our Solution: Foodieland makes cooking and food inspiration easier by offering:
-----------------------------------------------------------------------

✅ A wide range of recipes, blogs, and food stories in one place

✅ Chef-inspired tips and step-by-step cooking guides

✅ Save, share, and discover new dishes anytime

✅ Easy search for your favorite cuisines and ingredients

✅ Built with Flutter and Supabase for speed and reliability







🌍 Vision: The Bigger Picture
----------------------------------
✅“Foodieland is not just about recipes — it’s a food lover’s community.”

✅Inspiring people to cook more and eat better

✅Showcasing both global flavors and local Bangladeshi delicacies

✅Connecting foodies, home cooks, and chefs in one platform

✅Building a sustainable food culture through knowledge and creativity





💡 Key Features for Foodieland
  Feature	Description
-------------------------------------------------------------------------------------

🚀 Wide Range of Recipes	Explore diverse recipes from quick snacks to gourmet dishes

🚀 Food Blogs & Stories	Discover cooking tips, food culture, and inspiring stories

🚀 Save & Share Favorites	Bookmark your favorite recipes and share with friends & family

🚀 Smart Search & Filters	Find recipes by ingredients, cuisine, or cooking time easily

🚀 Step-by-Step Guides	Cook with confidence using detailed instructions and images

🚀 Community Driven	Connect with foodies, home cooks, and chefs in one place

🚀 Personalized Suggestions	Get recipe recommendations based on your taste & interests

🚀 Built with Flutter & Supabase	Fast, reliable performance powered by modern technology (PostgreSQL, Auth, Storage)



</td>
</tr>
</table>


<table>
<tr>
<td>


<details>
<summary><h2>📋 Table of Contents</h2></summary>

1. 👥 [Team Members](#-team-members)  
2. 🚀 [Project Overview](#-project-overview)  
3. 🎯 [Key Goals](#-key-goals)  
4. 🌟 [Why This Matters](#-why-this-matters)  
5. 🔧 [Technical Alignment](#-technical-alignment)  
6. 🏗️ [Project Structure: MVVM Architecture with Repository Pattern](#-project-structure-mvvm-architecture-with-repository-pattern)  
7. 🗃️ [Database Design](#-database-design)  
8. 🌐 [API Documentation](#-api-documentation)  
9. 💻 [Development Guidelines](#-development-guidelines)  
10. 🧪 [Testing](#-testing)  
11. 📚 [Resources](#-resources)  
12. 🤝 [Contributing](#-contributing)  

</details>

<div align="center">

## 👥 Team Members

| Name            | Role           | GitHub Profile                                           |
|-----------------|----------------|----------------------------------------------------------|
| Rasel Ahmed     | Team Leader    | [@raselahmedadnan](https://github.com/raselahmedadnan)   |
| Mehedi Hasan    | Member         | [@mhbabon](https://github.com/mhbabon)                   |
| Md. Shadhin Ali | Member         | [@uvcorn](http://github.com/uvcorn)                      |
| Fahima Rahmani  |  Member        | [@Fahima-eti](https://github.com/Fahima-eti)             |




Here's the updated **Technical Alignment** based on your **new project structure** (feature-based clean architecture with repository pattern):

---
## 🔧 **Technical Alignment**

- **Flutter Feature-Based Clean Architecture**:  
  Modular and scalable code organization, separating core services, features, models, repositories, views, and widgets for maintainability and clarity.

- **Repository Pattern**:  
  Each feature has its own repository layer that abstracts data sources (like APIs, databases), ensuring low coupling between UI and data logic.

- **GetX (State Management, Routing, Dependency Injection)**:  
  Lightweight and efficient solution for managing app state, navigation, and service dependencies across features.

- **Supabase & Firebase (or Backend Service)**:  
  Manages authentication, user-generated content, real-time updates, and database interactions securely.

- **Core Services**:  
  Includes reusable utilities like network caller, authentication service, validators, theme switching, custom widgets, and more, ensuring consistency across the app.
---


</div>

## 🏗️ **Project Structure: Feature-Based Clean Architecture with Repository Pattern**  
```
lib/

│   ├── lib
│       ├── components
│       ├── action_button
│       │     ├── action_button.dart
│       ├── custom_checkbox
│       │      ├── custom_checkbox.dart
│       ├── custom_dropdown_menu
│       │      ├── custom_dropdown_menu.dart
│       ├── custom_image
│       │      ├── custom_image.dart
│       ├── custom_network_image
│       │      ├── custom_network_image.dart
│       ├── custom_pin_code
│       │      ├── custom_pin_code.dart
│       ├── custom_text
│       │      ├── custom_text.dart
│       ├── custom_text_field
│       │      ├── custom_text_field.dart
│       ├── dynamic_textfield
│       │      ├── dynamic_text_field_list.dart
│       ├── input_card_container
│       │      ├── input_card_container.dart
│       ├── snackbar_helper
│       │      ├── snackbar_helper.dart
│  ├──  core
│       ├── dependency_injection
│       │      ├── dependency_injection.dart
│       │      ├── app.dart
│       │      ├── app_routes.dart
features
│       ├── auth
│       │      ├── controllers
│       │      ├── forgot_password_controller.dart
│       │      ├── otp_verify_controller.dart
│       │      ├── reset_password_controller.dart
│       │      ├── sign_in_controller.dart
│       │      ├── sign_up_controller.dart
│       │      ├── user_profile_controller.dart
│       ├── screens
│       │      ├── forget_password_screen.dart
│       │      ├── otp_verify_screen.dart
│       │      ├── reset_password_screen.dart
│       │      ├── sign_in_screen.dart
│       │      ├── sign_up_screen.dart
│       │      ├── user_profile_screen.dart
│       ├── blog
│       │      ├── blog_repository
│       │      ├     ├── blog_repo_function.dart
│       │      ├── data
│       │      ├     ├── blog_data.dart
│       │      ├── model
│       │      ├     ├── blog_model.dart
│       │      ├     ├── content_block_model.dart
│       │      ├── screen
│       │      ├     ├── blog_add_screen.dart
│       │      ├     ├── blog_details_screen.dart
│       │      ├     ├── blog_list_screen.dart
│       │      ├     ├── contain_blog.dart
│       │      ├     ├── login_popup_for_addpost.dart
│       │      ├── widgets
│       │      ├     ├── author_img.dart
│       │      ├     ├── blog_item.dart
│       │      ├     ├── cutom_blog_field.dart
│       │      ├     ├── paging_widget.dart
│       │      ├── categories/ui
│       │      ├── controllers
│       │      ├     ├── category_recipes_controller.dart
│       │      ├──screens
│       │      ├     ├── categories_item_card.dart
│       │      ├     ├── categories_items_list_screen.dart
│       │      ├     ├── categories_screen.dart
│       │      ├── common/ui
│       │      ├── controllers
│       │      ├     ├── favorite_controller.dart
│       ├──    │       ├─widgets
add_to_favorite_button.dart
icon_and_title_widget.dart
network_image_with_error_image.dart
recent_recipe_card.dart
recipe_card.dart
contact_us_section/ui
controller
contact_us_controller.dart
screens
contact_us_screen.dart
home
data/model
category_model.dart
recipes_list_model.dart
sliders_model.dart
ui
controllers
category_controller.dart
random_recipes_controller.dart
recipes_list_controller.dart
sliders_controller.dart
screens
favorite_list_screen.dart
home_screen.dart
recipes_screen.dart
widgets
home_carousel_slider.dart
recipe_section
data
ui
screens
recipe_details_screen.dart
recipe_post_screen.dart
widgets
food_speciality_section.dart
ingredients_section.dart
nutrition_info_section.dart
preparation_steps_section.dart
splash_screen
splash_screens.dart
utils
app_colors
app_colors.dart
app_icons
app_icons.dart
app_images
app_images.dart
app_strings
app_strings.dart
app_theme
app_theme.dart
assets_path
assets_path.dart
main.dart




```
## 📌 Directory Breakdown

- **`features/`** →  
 Each feature (e.g., Auth, Category, Class, Subject, Chapter, Content) contains:
    - `controllers/` → Handles state management (using GetX).
    - `models/` → Defines data models specific to that feature.
    - `screens/` → Contains the UI screens and views for the feature.
   

- **`core/`** →  
  Common app-wide utilities and services:
    - `network/` → HTTP and Supabase interaction layers.
    - `theme/` → Colors, typography, and app-wide theming constants.
    - `utils/` → Helper functions, extensions, reusable widgets.

- **`routes/`** →  
  Centralized navigation and route management using GetX routing.

- **`bindings/`** →  
  Feature bindings for dependency injection (GetX Bindings).
---





<p align="center">

🌐 API Documentation for Foodieland
Category	Description
🔐 Auth Endpoints	Sign Up, Login, Forgot Password, OAuth (Google)
📝 Blog Management	Create, read, update, and delete blog posts; upload blog images; fetch blog lists
📰 Recipe Management	CRUD for recipes; recipe details; upload recipe images
🧑‍🍳 Author Management	Author profiles, profile images, bio, and posts
💾 Media Storage	Upload and manage images for blogs, recipes, and authors
❤️ Wishlist / Favorites	Add recipes or blogs to favorites for easy access
📊 Analytics (Optional)	Track popular blogs, recipe views, author stats
💻 Dart Examples	Code snippets with http, supabase_flutter, and Getx


## 💻 **Development Guidelines**  

| 🔧 Topic | ✅ Best Practices |
|---------|------------------|
| 📐 **Architecture** | MVVM: `/lib/view`, `/lib/viewmodel`, `/lib/model` |
| 🧠 **State Management** | GetX (minimal, reactive) |
| 🛡️ **Security & Clean Code** | Follow Supabase + Firebase + Flutter safety standards |


## 🧪 **Testing Strategy**

| 🧪 Test Type | 🔍 Description |
|-------------|----------------|
| 🧠 **Unit Tests** | Validates ViewModel logic & services |
| 🧩 **Widget Tests** | UI components and layouts |
| 🧪 **Supabase Mock Tests** | Use mocks for secure backend logic testing |
</p>



</td>
</tr>
</table>
