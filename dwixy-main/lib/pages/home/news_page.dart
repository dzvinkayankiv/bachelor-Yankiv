import 'package:dwixy/bloc/news_bloc/news_bloc.dart';
import 'package:dwixy/consts/colors.dart';
import 'package:dwixy/consts/monserat_styles.dart';
import 'package:dwixy/pages/home/single_news_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  @override
  void initState() {
    super.initState();
    context.read<NewsBloc>().add(GetNews());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: BlocBuilder<NewsBloc, NewsState>(
        builder: (context, state) {
          if (state is NewsError) {
            return Center(child: Text(state.message));
          } else if (state is NewsLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is NewsLoaded) {
            return ListView.builder(
              itemCount: state.news.length,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      state.news[index].title,
                      style: MonseratStyles.montserrat20W700Black,
                      overflow: TextOverflow.fade,
                      maxLines: 3,
                    ),
                    SizedBox(
                      height: 200,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: state.news[index].news.length,
                        itemBuilder: (BuildContext context, int rowIndex) {
                          final singleNews = state.news[index].news[rowIndex];
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => SingleNewsPage(news: singleNews),
                                ),
                              );
                            },
                            child: SizedBox(
                              height: 200,
                              width: 170,
                              child: Card(
                                color: ((index % 2 == 0) ? (rowIndex % 2 == 0) : (rowIndex % 2 != 0))
                                    ? AppColors.pink2
                                    : AppColors.blueLight,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.network(
                                        singleNews.imageUrl,
                                        width: 150,
                                        height: 120,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        singleNews.title,
                                        style: MonseratStyles.montserrat16W600Black,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            );
          }
          return SizedBox();
        },
      ),
    );
  }
}
