class CategoryModel {
  final String uuid;
  final String categoryName;
  final String imageUrl;

  CategoryModel({required this.uuid, required this.imageUrl, required this.categoryName});

  factory CategoryModel.fromMap(Map<String, dynamic> data) {
    return CategoryModel(
      uuid: data['id'] ?? '',
      categoryName: data['name'] ?? '',
      imageUrl: data['image_url'] ?? '',
    );
  }
}
