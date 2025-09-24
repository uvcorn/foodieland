import 'package:flutter/material.dart';
import 'package:foodieland/features/recipe_section/data/model/recipe_details_model.dart';

import '../../../../components/custom_text/custom_text.dart';
import '../../../../utils/app_colors/app_colors.dart';

class NutritionInfoSection extends StatelessWidget {
  final List<NutritionInfo> nutritionInfo;

  const NutritionInfoSection({super.key, required this.nutritionInfo});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        CustomText(
          text: "Nutrition Information",

          fontSize: 16,

          fontWeight: FontWeight.bold,
        ),

        const SizedBox(height: 8),

        Card(
          color: AppColors.lightBlue,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),

          elevation: 2,

          child: Padding(
            padding: const EdgeInsets.all(12.0),

            child: Column(
              children:
                  nutritionInfo.map((item) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                        children: [
                          CustomText(
                            text: item.title,

                            fontSize: 14,

                            fontWeight: FontWeight.bold,
                          ),

                          CustomText(
                            text: item.description,

                            fontSize: 14,

                            fontWeight: FontWeight.normal,
                          ),
                        ],
                      ),
                    );
                  }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
