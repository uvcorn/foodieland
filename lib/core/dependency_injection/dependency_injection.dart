import 'package:foodieland/features/auth/controllers/user_profile_controller.dart';
import 'package:foodieland/features/categories/ui/controllers/category_recipes_controller.dart';
import 'package:foodieland/features/common/ui/controllers/favorite_controller.dart';
import 'package:foodieland/features/home/ui/controllers/category_controller.dart';
import 'package:foodieland/features/home/ui/controllers/random_recipes_controller.dart';
import 'package:foodieland/features/home/ui/controllers/recipes_list_controller.dart';
import 'package:foodieland/features/home/ui/controllers/sliders_controller.dart';
import 'package:foodieland/features/recipe_section/data/controllers/recipe_controller.dart';
import 'package:get/get.dart';

import '../../features/auth/controllers/forgot_password_controller.dart';
import '../../features/auth/controllers/otp_verify_controller.dart';
import '../../features/auth/controllers/reset_password_controller.dart';
import '../../features/auth/controllers/sign_in_controller.dart';
import '../../features/auth/controllers/sign_up_controller.dart';
import '../../features/contact_us_section/ui/controller/contact_us_controller.dart';

class DependencyInjection extends Bindings {
  @override
  void dependencies() {
    ///==========================Owner section==================

    Get.lazyPut(() => SignUpController(), fenix: true);
    Get.lazyPut(() => SignInController(), fenix: true);
    Get.lazyPut(() => OtpVerifyController(), fenix: true);
    Get.lazyPut(() => ForgotPasswordController(), fenix: true);
    Get.lazyPut(() => ResetPasswordController(), fenix: true);
    Get.lazyPut(() => RecipesListController(), fenix: true);
    Get.lazyPut(() => RandomRecipesController(), fenix: true);
    Get.lazyPut(() => CategoryRecipesController(), fenix: true);
    Get.lazyPut(() => FavoritesController(), fenix: true);
    Get.lazyPut(() => UserProfileController(), fenix: true);
    Get.lazyPut(() => RecipeController(), fenix: true);
    Get.lazyPut(() => ContactUsController(), fenix: true);

    Get.put(SlidersController());
    Get.put(CategoryController());
  }
}
