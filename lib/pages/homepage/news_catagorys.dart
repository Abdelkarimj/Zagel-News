import 'package:flutter/material.dart';
import 'package:zagel/global/newstile.dart';
import 'package:zagel/models/category_model.dart';
import 'package:zagel/models/news_model.dart';
import 'package:zagel/global/news.dart';

class NewsCatagorys extends StatefulWidget {
  final CategoryModel selectedCategory;

  const NewsCatagorys({Key? key, required this.selectedCategory})
      : super(key: key);

  @override
  State<NewsCatagorys> createState() => _NewsCatagorysState();
}

class _NewsCatagorysState extends State<NewsCatagorys> {
  late Future<List<NewsModel>> categoryNews;

  @override
  void initState() {
    super.initState();
    categoryNews = fetchCategoryNews();
  }

  Future<List<NewsModel>> fetchCategoryNews() async {
    News news = News();
    return await news.getNewsForCategory(widget.selectedCategory.categoryname);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Text(
          widget.selectedCategory.categoryname,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: Colors.grey[800],
      ),
      body: FutureBuilder<List<NewsModel>>(
        future: categoryNews,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No news available for this category'));
          } else {
            List<NewsModel> newsList = snapshot.data!;
            return ListView.builder(
              itemCount: newsList.length,
              itemBuilder: (context, index) {
                return Column(
                  children: <Widget>[
                    NewsTile(
                      newsimgurl: newsList[index].urlToImage,
                      newstitle: newsList[index].title,
                      newsdescription: newsList[index].description,
                      newsurl: newsList[index].articleUrl,
                      newsauthor: newsList[index].newsauthor.toString(),
                    ),
                    Divider(height: 1, color: Colors.grey),
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }
}
