class RecipesListModel{
  final String id;
  final String imageUrl;
  final String title;
  final int cookingTime;
  final String category;

  RecipesListModel({required this.id,required this.imageUrl, required this.title, required this.cookingTime, required this.category});

  factory RecipesListModel.fromMap(Map<String,dynamic> data){
    return RecipesListModel(
         id: data['id'],
        imageUrl: data['image_url'] ?? '',
        title: data['title'] ?? '',
        cookingTime: data['cooking_time'] ?? '',
        category: data['category'] ?? '');
  }
}