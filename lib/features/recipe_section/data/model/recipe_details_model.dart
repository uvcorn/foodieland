class Ingredient {
  final String name;
  final String quantity;

  Ingredient({required this.name, required this.quantity});

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      name: json['name'] ?? '',
      quantity: json['quantity'] ?? '',
    );
  }
}

class PreparationStep {
  final int stepOrder;
  final String title;
  final String description;

  PreparationStep({
    required this.stepOrder,
    required this.title,
    required this.description,
  });

  factory PreparationStep.fromJson(Map<String, dynamic> json) {
    return PreparationStep(
      stepOrder: json['step_order'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
    );
  }
}

class Speciality {
  final String title;
  final String description;

  Speciality({required this.title, required this.description});

  factory Speciality.fromJson(Map<String, dynamic> json) {
    return Speciality(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
    );
  }
}

class NutritionInfo {
  final String title;
  final String description;

  NutritionInfo({required this.title, required this.description});

  factory NutritionInfo.fromJson(Map<String, dynamic> json) {
    return NutritionInfo(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
    );
  }
}

class RecipeDetailsModel {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final int cookingTime;
  final String category;
  final DateTime createdAt;
  final List<Ingredient> ingredients;
  final List<PreparationStep> preparationSteps;
  final List<Speciality> specialities;
  final List<NutritionInfo> nutritionInfo;

  RecipeDetailsModel({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.cookingTime,
    required this.category,
    required this.createdAt,
    required this.ingredients,
    required this.preparationSteps,
    required this.specialities,
    required this.nutritionInfo,
  });

  factory RecipeDetailsModel.fromJson(Map<String, dynamic> json) {
    return RecipeDetailsModel(
      id: json['id'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['image_url'] ?? '',
      cookingTime: json['cooking_time'] ?? 0,
      category: json['category'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
      ingredients:
          (json['ingredients'] as List<dynamic>? ?? [])
              .map((e) => Ingredient.fromJson(e))
              .toList(),
      preparationSteps:
          (json['preparation_steps'] as List<dynamic>? ?? [])
              .map((e) => PreparationStep.fromJson(e))
              .toList(),
      specialities:
          (json['food_specialities'] as List<dynamic>? ?? [])
              .map((e) => Speciality.fromJson(e))
              .toList(),
      nutritionInfo:
          (json['nutrition_info'] as List<dynamic>? ?? [])
              .map((e) => NutritionInfo.fromJson(e))
              .toList(),
    );
  }
}
