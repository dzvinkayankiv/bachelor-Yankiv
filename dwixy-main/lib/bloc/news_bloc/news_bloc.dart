import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dwixy/models/news_detail_model.dart';
import 'package:dwixy/models/news_model.dart';
import 'package:meta/meta.dart';

part 'news_event.dart';
part 'news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final db = FirebaseFirestore.instance;

  NewsBloc() : super(NewsInitial()) {
    on<GetNews>((event, emit) async {
      emit(NewsLoading());
      try {
        final mainCollection = db.collection('news');
        final mainDocs = await mainCollection.get();

        List<NewsModel> newsModels = [];

        for (var doc in mainDocs.docs) {
          final categoryTitle = doc.data()['title'] ?? '';
          final subNewsSnapshot = await mainCollection.doc(doc.id).collection('news').get();

          final subNews = subNewsSnapshot.docs.map((subDoc) {
            return NewsDetailModel.fromJson(subDoc.data());
          }).toList();

          newsModels.add(NewsModel(title: categoryTitle, news: subNews));
        }

        emit(NewsLoaded(newsModels));
      } catch (e) {
        emit(NewsError("Error: $e"));
      }
    });
  }
}
