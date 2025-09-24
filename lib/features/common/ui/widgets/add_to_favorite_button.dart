import 'package:flutter/material.dart';
import 'package:foodieland/components/snackbar_helper/snackbar_helper.dart';
import 'package:foodieland/features/common/ui/controllers/favorite_controller.dart';
import 'package:foodieland/utils/app_colors/app_colors.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddToFavoriteButton extends StatelessWidget {
  const AddToFavoriteButton({
    super.key,
    this.screenSizeWidth,
    required this.recipeId,
    required this.addToFavorite,
  });

  final double? screenSizeWidth;
  final String recipeId;
  final Function(bool) addToFavorite;

  @override
  Widget build(BuildContext context) {
    final FavoritesController _favoritesController =
    Get.find<FavoritesController>();



    return Obx(() {
      final user = Supabase.instance.client.auth.currentUser;

        final isFavorite =  _favoritesController.isFavorite(recipeId);



      Future<void> onTapButton()async{
        if(user != null){

          if (isFavorite) {
            await _favoritesController.removeFromFavorites(recipeId);
            SnackbarHelper.show(
              message: "Successfully removed recipe from Favorites",
              isSuccess: true,
            );
            addToFavorite(false);
          } else {
            await _favoritesController.addToFavorites(recipeId);
            SnackbarHelper.show(
              message: "Successfully added recipe to Favorites",
              isSuccess: true,
            );
            addToFavorite(true);
          }

        }else{
          SnackbarHelper.show(message: "Please Login First", isSuccess: false,);
        }


      }

      return IconButton(
        padding: EdgeInsets.zero,
        onPressed: onTapButton,
        icon: Icon(
          isFavorite ? Icons.favorite : Icons.favorite_border,
          color: isFavorite ? Colors.red : AppColors.mediumGray,
          size: screenSizeWidth,
        ),
      );
    });
  }
}
