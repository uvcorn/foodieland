class SlidersModel {
  final String uuid;
  final String url;

  SlidersModel({required this.uuid, required this.url});

  factory SlidersModel.fromMap(Map<String, dynamic> data) {
    return SlidersModel(uuid: data['id'] ?? '', url: data['url'] ?? '');
  }
}
