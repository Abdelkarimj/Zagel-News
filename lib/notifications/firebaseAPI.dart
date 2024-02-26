import 'dart:math';
import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zagel/global/news.dart';
import 'package:zagel/models/news_model.dart';

List<NewsModel> newslist = [];

class NotificationManager {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  NotificationManager() {
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = DarwinInitializationSettings();
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // test call to the Notification
    //scheduleNotification();

    // Schedule periodic notifications every 1 hours
    const Duration period = const Duration(hours: 3);
    Timer.periodic(period, (Timer t) => scheduleNotification());
  }

  Future<void> scheduleNotification() async {
    News newsclass = News();
    await newsclass.getNews();
    newslist = newsclass.news;

    // Get the current user
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String userId = user.uid;

      // Query Firestore to get saved notifications
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('user_bookmarks')
              .doc(userId)
              .collection('Notifications')
              .get();

      // save the authors in the Fires store to
      List<String> savedNewsAuthors = querySnapshot.docs
          .map((doc) => doc.data()['author'] as String)
          .toList();

      print("Saved News Authors: $savedNewsAuthors");
      print('News List: $newslist');
      // Filter the newslist based on saved newsauthors
      List<NewsModel> filteredNewsList = newslist
          .where((news) => savedNewsAuthors.contains(news.newsauthor))
          .toList();

      print("Filtered News List: $filteredNewsList");

      // Check if there are news articles matching saved newsauthors
      if (filteredNewsList.isNotEmpty) {
        // Select a random news article from the filtered list
        Random random = Random();
        int randomIndex = random.nextInt(filteredNewsList.length);
        NewsModel randomNews = filteredNewsList[randomIndex];

        // Show notification
        showNotification(randomNews.title,
            '${randomNews.description}\nAuthor: ${randomNews.newsauthor}');
      }
    }
  }

  void showNotification(String title, String body) async {
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
        'news_channel', 'News Channel',
        importance: Importance.max, priority: Priority.high, showWhen: false);
    var iOSPlatformChannelSpecifics = DarwinNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin
        .show(0, title, body, platformChannelSpecifics, payload: 'item x');
  }
}
