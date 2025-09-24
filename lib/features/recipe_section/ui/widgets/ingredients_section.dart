import 'package:flutter/material.dart';
import 'package:foodieland/features/recipe_section/data/model/recipe_details_model.dart';

import '../../../../components/custom_text/custom_text.dart';
import '../../../../utils/app_colors/app_colors.dart';

class IngredientsSection extends StatelessWidget {
  final List<Ingredient> ingredients;

  const IngredientsSection({super.key, required this.ingredients});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        CustomText(
          text: "Ingredients",

          fontSize: 16,

          fontWeight: FontWeight.bold,
        ),

        const SizedBox(height: 8),

        ListView.builder(
          shrinkWrap: true,

          physics: NeverScrollableScrollPhysics(),

          itemCount: ingredients.length,

          itemBuilder: (context, index) {
            final item = ingredients[index];

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.local_dining, size: screenWidth * 0.04),

                  SizedBox(width: screenWidth * 0.03),

                  CustomText(
                    text:
                        "${item.name} - ${item.quantity}",

                    fontSize: 12,

                    fontWeight: FontWeight.w400,
                    overflow: TextOverflow.ellipsis,
                    color: AppColors.black,
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
