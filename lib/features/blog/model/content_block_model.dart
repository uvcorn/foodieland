class ContentBlock {
  final String title;
  final String description;

  ContentBlock({
    required this.title,
    required this.description,
  });

  factory ContentBlock.fromMap(Map<String, dynamic> map) {
    return ContentBlock(
      title: map['title'] ?? '',
      description: map['description'] ?? '',
    );
  }
}
