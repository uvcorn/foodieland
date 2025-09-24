import 'package:flutter/material.dart';
import 'package:foodieland/features/recipe_section/data/model/recipe_details_model.dart';
import '../../../../components/custom_text/custom_text.dart';

class RecipeSpecialitySection extends StatelessWidget {
  final List<Speciality> specialityData;

  const RecipeSpecialitySection({super.key, required this.specialityData});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CustomText(
          text: "Food Speciality",
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        const SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: specialityData.length,
          itemBuilder: (context, index) {
            final item = specialityData[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(fontSize: 14, color: Colors.black),
                  children: [
                    TextSpan(
                      text: "${item.title}: ",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: item.description),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
