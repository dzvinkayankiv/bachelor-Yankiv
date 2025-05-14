class NewsDetailModel {
  final String title;
  final String imageUrl;
  final String text;

  NewsDetailModel({
    required this.title,
    required this.imageUrl,
    required this.text,
  });

  factory NewsDetailModel.fromJson(Map<String, dynamic> json) {
    return NewsDetailModel(
      title: json['title'] ?? '',
      text: json['text'] ?? '',
      imageUrl: json['imageURL'] ?? '',
    );
  }
}