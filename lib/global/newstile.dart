import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:zagel/pages/homepage/news_view.dart';

class NewsTile extends StatelessWidget {
  final String newsimgurl, newstitle, newsdescription, newsurl, newsauthor;

  NewsTile({
    Key? key,
    required this.newsimgurl,
    required this.newstitle,
    required this.newsdescription,
    required this.newsurl,
    required this.newsauthor,
  }) : super(key: key);

  Future<void> saveNewsToFirestore() async {
    // Get the current user
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      String userId = user.uid;

      String sanitizedNewsUrl = newsurl.replaceAll('/', '_');

      DocumentReference newsRef = FirebaseFirestore.instance
          .collection('user_bookmarks')
          .doc(userId)
          .collection('bookmarks')
          .doc(sanitizedNewsUrl);

      if (!(await newsRef.get()).exists) {
        await newsRef.set({
          'title': newstitle,
          'description': newsdescription,
          'imageUrl': newsimgurl,
          'articleUrl': newsurl,
          'author': newsauthor,
        });
      }
    }
  }

//add to history
  Future<void> savetoHistory() async {
    // Get the current user
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      String userId = user.uid;

      // Sanitize newsurl before using it as the document path
      String sanitizedNewsUrl = newsurl.replaceAll('/', '_');

      // Create a Firestore document reference for the news article
      DocumentReference newsRef = FirebaseFirestore.instance
          .collection('user_bookmarks') // Use 'user_bookmarks' collection
          .doc(userId)
          .collection('History')
          .doc(sanitizedNewsUrl);

      // Check if the news article is already saved to prevent duplicates
      if (!(await newsRef.get()).exists) {
        // Save news details to Firestore
        await newsRef.set({
          'title': newstitle,
          'description': newsdescription,
          'imageUrl': newsimgurl,
          'articleUrl': newsurl,
          'author': newsauthor,
        });
      }
    }
  }

  Future<void> saveNotificationToFirestore() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      String userId = user.uid;

      String name = newsauthor;

      DocumentReference newsRef = FirebaseFirestore.instance
          .collection('user_bookmarks')
          .doc(userId)
          .collection('Notifications')
          .doc(name);

      if (!(await newsRef.get()).exists) {
        await newsRef.set({
          'author': newsauthor,
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        savetoHistory();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NewsView(
              newsurl: newsurl,
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              newstitle,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    newsimgurl,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        newsdescription,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(height: 8),

                      // Icon buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(
                              Icons.notifications,
                              color: Colors.blue,
                            ),
                            onPressed: () {
                              saveNotificationToFirestore();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('You will get Notifeid!'),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.bookmark_border,
                              color: Colors.blue,
                            ),
                            onPressed: () {
                              // Call the function to save news to Firestore
                              saveNewsToFirestore();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('News saved to Bookmarks'),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.share, color: Colors.blue),
                            onPressed: () {
                              Share.share(newsurl);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
