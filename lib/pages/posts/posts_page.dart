import 'package:flutter/material.dart';
import 'package:zagel/global/category.dart';
import 'package:zagel/global/news.dart';
import 'package:zagel/global/newstile.dart';
import 'package:zagel/models/category_model.dart';
import 'package:zagel/models/news_model.dart';
import 'package:zagel/pages/homepage/news_catagorys.dart';
import 'package:zagel/global/prefrences.dart';

class PostsPage extends StatefulWidget {
  const PostsPage({Key? key}) : super(key: key);

  @override
  State<PostsPage> createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  List<NewsModel> newsList = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  CategoryModel? selectedCategory;
  List<CategoryModel> categories = getCategories();

  // Function to handle news search
  Future<void> searchNews(String query) async {
    News news = News();
    keyword = query;
    await news.getNewsByKeyword();
    setState(() {
      newsList = news.news;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Text(
          "Search",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: Colors.grey[800],
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: Icon(Icons.search, color: Colors.white),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(color: Colors.white),
                ),
                filled: true,
                fillColor: Colors.grey[800],
              ),
              onChanged: (value) {
                searchNews(_searchController.text);
              },
            ),
          ),

          // Explore Categories
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Explore Categories",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    itemBuilder: (context, idx) {
                      return CategoryBar(
                        categoryimageurl: categories[idx].categoryimageurl,
                        categoryname: categories[idx].categoryname,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 3, color: Colors.grey),

          // Display news using NewsTile

          SizedBox(
            height: 500,
            child: Column(
              children: [
                if (newsList.isNotEmpty)
                  Expanded(
                    child: ListView.builder(
                      itemCount: newsList.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            NewsTile(
                              newsimgurl: newsList[index].urlToImage,
                              newstitle: newsList[index].title,
                              newsdescription: newsList[index].description,
                              newsurl: newsList[index].articleUrl,
                              newsauthor: newsList[index].newsauthor.toString(),
                            ),
                            Divider(color: Colors.grey, height: 1),
                          ],
                        );
                      },
                    ),
                  ),
                if (newsList.isEmpty)
                  Text(
                    'No news found for ${keyword}. :(',
                    style: TextStyle(color: Colors.white),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryBar extends StatelessWidget {
  final String categoryimageurl, categoryname;

  CategoryBar({required this.categoryimageurl, required this.categoryname});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        CategoryModel selectedCategory = CategoryModel(
          categoryname: categoryname,
          categoryimageurl: categoryimageurl,
        );

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                NewsCatagorys(selectedCategory: selectedCategory),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(right: 8), // Adjust margin for spacing
        child: Column(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.network(
                categoryimageurl,
                fit: BoxFit.cover,
                width: 80, // Adjust width
                height: 80, // Adjust height
              ),
            ),
            SizedBox(height: 4), // Add some space between image and text
            Text(
              categoryname,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
