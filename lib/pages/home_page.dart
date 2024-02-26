import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zagel/pages/bookmarks/bookmark_page.dart';
import 'package:zagel/pages/homepage/news_page.dart';
import 'package:zagel/pages/posts/posts_page.dart';
import 'package:zagel/pages/settings/settings_page.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;

  //Signout Function
  void UserSignOut() {
    FirebaseAuth.instance.signOut();
  }

  void menueNav(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  final List<Widget> menuePages = [
    const FeedPage(),
    PostsPage(),
    const BookmarksPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: menuePages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey[800],
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        unselectedItemColor: Colors.white,
        selectedItemColor: Colors.blue,
        onTap: menueNav,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.newspaper_sharp), label: 'Zajel Feed'),
          BottomNavigationBarItem(
              icon: Icon(Icons.library_books), label: 'Search'),
          BottomNavigationBarItem(
              icon: Icon(Icons.bookmarks), label: 'Bookmarks'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}
