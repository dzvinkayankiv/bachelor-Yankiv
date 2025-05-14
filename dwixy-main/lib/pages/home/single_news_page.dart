import 'package:dwixy/consts/roboto_styles.dart';
import 'package:dwixy/models/news_detail_model.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class SingleNewsPage extends StatefulWidget {
  final NewsDetailModel news;

  const SingleNewsPage({super.key, required this.news});

  @override
  State<SingleNewsPage> createState() => _SingleNewsPageState();
}

class _SingleNewsPageState extends State<SingleNewsPage> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(title: Text(widget.news.title)),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: HtmlWidget(
              widget.news.text,
              textStyle: RobotoStyles.roboto16W500Black,
              customStylesBuilder: (element) {
                if (element.localName == 'p') {
                  return {'color': 'black', 'font-size': '18px'};
                }
                return null;
              },
              customWidgetBuilder: (element) {
                if (element.localName == 'img') {
                  var imageUrl = element.attributes['src'] ?? '';
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
                      placeholder: (context, url) => CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  );
                }
                return null;
              },
            ),
          ),
        ),
      ),
    );
  }
}