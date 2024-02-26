import 'dart:convert';
import 'package:zagel/models/news_model.dart';
import 'package:http/http.dart' as http;
import 'package:zagel/global/prefrences.dart';

class News {
  List<NewsModel> news = [];
  String API = "ac0da06a6031439db63818970f0d7316";
  Future<void> getNews() async {
    // Clear the list before fetching new articles
    news.clear();

    String url =
        "https://newsapi.org/v2/top-headlines?language=$language&pageSize=100&apiKey=$API";
    try {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        if (jsonData['status'] == "ok") {
          jsonData["articles"].forEach((element) {
            if (element['urlToImage'] != null &&
                element['description'] != null) {
              NewsModel article = NewsModel(
                newsauthor: element["author"],
                title: element['title'],
                description: element['description'],
                urlToImage: element['urlToImage'],
                articleUrl: element["url"],
              );
              news.add(article);
            }
          });
        }
      } else {
        throw Exception('Failed to load news');
      }
    } catch (e) {
      print('Error fetching news: $e');
    }
  }

  Future<List<NewsModel>> getNewsForCategory(String category) async {
    // Clear the list before fetching new articles
    news.clear();

    String url =
        "https://newsapi.org/v2/top-headlines?language=$language&pageSize=50&category=$category&apiKey=$API";
    try {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        if (jsonData['status'] == "ok") {
          jsonData["articles"].forEach((element) {
            if (element['urlToImage'] != null &&
                element['description'] != null) {
              NewsModel article = NewsModel(
                newsauthor: element["author"],
                title: element['title'],
                description: element['description'],
                urlToImage: element['urlToImage'],
                articleUrl: element["url"],
              );
              news.add(article);
            }
          });
        }
      } else {
        throw Exception("Invalid Api Key: $API ");
      }
    } catch (e) {
      print('Error fetching news: $e');
    }
    return news;
  }

  Future<List<NewsModel>> getNewsByKeyword() async {
    // Clear the list before fetching new articles
    news.clear();

    String url =
        "https://newsapi.org/v2/everything?q=$keyword&pageSize=50&apiKey=$API";
    try {
      var response = await http.get(Uri.parse(url));
      print('API response for keyword search: ${response.body}');
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        if (jsonData['status'] == "ok") {
          jsonData["articles"].forEach((element) {
            if (element['urlToImage'] != null &&
                element['description'] != null) {
              NewsModel article = NewsModel(
                newsauthor: element["author"],
                title: element['title'],
                description: element['description'],
                urlToImage: element['urlToImage'],
                articleUrl: element["url"],
              );
              news.add(article);
            }
          });
        }
      } else {
        throw Exception('Failed to load news');
      }
    } catch (e) {
      print('Error fetching news: $e');
    }
    return news;
  }

  Future<void> getNewsdate() async {
    // Clear the list before fetching new articles
    news.clear();

    String url =
        "https://newsapi.org/v2/everything?q=e OR ا&language=$language&pageSize=100&sortBy=popularity&from=$from&to=$to&apiKey=c8f139c8c8a74d979dca4e064a0f897c";
    try {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        if (jsonData['status'] == "ok") {
          jsonData["articles"].forEach((element) {
            if (element['urlToImage'] != null &&
                element['description'] != null) {
              NewsModel article = NewsModel(
                newsauthor: element["author"],
                title: element['title'],
                description: element['description'],
                urlToImage: element['urlToImage'],
                articleUrl: element["url"],
              );
              news.add(article);
            }
          });
        }
      } else {
        throw Exception('Failed to load news');
      }
    } catch (e, stackTrace) {
      print('--getNewsDATA  Error fetching news: $e');
      print('Exception type: ${e.runtimeType}');
      print(stackTrace);
      print("---------------------------------------");
      print(from);
      print(to);
    }
  }
}
