import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zagel/pages/homepage/news_view.dart';

class BookmarksPage extends StatefulWidget {
  const BookmarksPage({Key? key}) : super(key: key);

  @override
  _BookmarksPageState createState() => _BookmarksPageState();
}

class _BookmarksPageState extends State<BookmarksPage> {
  late Future<List<DocumentSnapshot>> bookmarkedNews;

  @override
  void initState() {
    super.initState();
    bookmarkedNews = getBookmarkedNews();
  }

  Future<List<DocumentSnapshot>> getBookmarkedNews() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      String userId = user.uid;

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('user_bookmarks')
          .doc(userId)
          .collection('bookmarks')
          .get();

      return querySnapshot.docs;
    }

    return [];
  }

  Future<void> removeBookmark(DocumentSnapshot bookmark) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      String userId = user.uid;

      String sanitizedNewsUrl =
          bookmark['articleUrl'].toString().replaceAll('/', '_');

      await FirebaseFirestore.instance
          .collection('user_bookmarks')
          .doc(userId)
          .collection('bookmarks')
          .doc(sanitizedNewsUrl)
          .delete();

      // Refresh the list of bookmarks after removal
      setState(() {
        bookmarkedNews = getBookmarkedNews();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Bookmarks',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: Colors.grey[800],
      ),
      body: Container(
        color: Colors.grey[900],
        child: FutureBuilder<List<DocumentSnapshot>>(
          future: bookmarkedNews,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }

            List<DocumentSnapshot> bookmarks = snapshot.data ?? [];

            if (bookmarks.isEmpty) {
              return Center(
                child: Text(
                  'No bookmarks yet.',
                  style: TextStyle(color: Colors.white),
                ),
              );
            }

            return ListView.builder(
              itemCount: bookmarks.length,
              itemBuilder: (context, index) {
                DocumentSnapshot bookmark = bookmarks[index];
                Map<String, dynamic> data =
                    bookmark.data() as Map<String, dynamic>;

                return Card(
                  margin: EdgeInsets.all(8.0),
                  color: Colors.grey[800],
                  elevation: 2.0,
                  child: ListTile(
                    contentPadding: EdgeInsets.all(8.0),
                    title: Text(
                      data['title'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            data['imageUrl'],
                            width: double.infinity,
                            height: 150,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          data['description'],
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(
                                Icons.bookmark_remove,
                                color: Colors.blue,
                              ),
                              onPressed: () {
                                // Call the function to remove bookmark
                                removeBookmark(bookmark);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.open_in_browser),
                              color: Colors.blue,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => NewsView(
                                      newsurl: data['articleUrl'],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
