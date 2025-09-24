class Blog {
  final String id;
  final String title;
  final String subtitle;
  final String? image;
  final String author;
  final String? authorImg;
  final DateTime date;
  final String? description;

  Blog({
    required this.id,
    required this.title,
    required this.subtitle,
    this.image,
    required this.author,
    this.authorImg,
    required this.date,
    this.description,
  });

  factory Blog.fromMap(Map<String, dynamic> map) {
    try {} catch (e) {}
    return Blog(
      id: map['id'].toString(),
      title: map['title'] ?? '',
      subtitle: map['subtitle'] ?? 'No description available',
      image: map['image_url'],
      author: map['author'] ?? 'Unknown',
      authorImg: map['author_img'],
      date: DateTime.tryParse(map['date'] ?? '') ?? DateTime.now(),
      description: map['description'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'subtitle': subtitle,
      'image_url': image,
      'user_name': author,
      'user_avatar': authorImg,
      'date': date.toIso8601String(),
      'description': description,
    };
  }
}
