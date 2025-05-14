part of 'news_bloc.dart';

@immutable
sealed class NewsState {}

final class NewsInitial extends NewsState {}

final class NewsLoading extends NewsState {}

final class NewsLoaded extends NewsState {
  final List<NewsModel> news;

  NewsLoaded(this.news);
}

final class NewsError extends NewsState {
  final String message;

  NewsError(this.message);
}