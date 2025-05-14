import 'news_detail_model.dart';

class NewsModel {
  final String title;
  final List<NewsDetailModel> news;

  NewsModel({
    required this.title,
    required this.news,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      title: json['title'] ?? '',
      news: (json['news'] as List<dynamic>?)
          ?.map((item) => NewsDetailModel.fromJson(item as Map<String, dynamic>))
          .toList() ??
          [],
    );
  }
}