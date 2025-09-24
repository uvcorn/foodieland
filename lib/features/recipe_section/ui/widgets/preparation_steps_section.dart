import 'package:flutter/material.dart';
import 'package:foodieland/features/recipe_section/data/model/recipe_details_model.dart';

import '../../../../components/custom_text/custom_text.dart';
import '../../../../utils/app_colors/app_colors.dart';

class PreparationStepsSection extends StatelessWidget {
  final List<PreparationStep> preparationSteps;

  const PreparationStepsSection({super.key, required this.preparationSteps});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        CustomText(
          text: "Step-by-Step Preparation",

          fontSize: 16,

          fontWeight: FontWeight.bold,
        ),

        const SizedBox(height: 8),

        ListView.builder(
          shrinkWrap: true,

          physics: NeverScrollableScrollPhysics(),

          itemCount: preparationSteps.length,

          itemBuilder: (context, index) {
            final item = preparationSteps[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),

              child: Row(
                children: [
                  Text(
                    "${item.title}. ",

                    style: TextStyle(
                      fontSize: 14,

                      fontWeight: FontWeight.bold,

                      color: Colors.black,
                    ),
                  ),

                  SizedBox(width: screenWidth * 0.01),

                  Expanded(
                    child: CustomText(
                      text: item.description,
                      overflow: TextOverflow.ellipsis,
                      fontSize: 12,

                      fontWeight: FontWeight.w400,

                      color: AppColors.black,

                      maxLines: null,
                    ),
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
