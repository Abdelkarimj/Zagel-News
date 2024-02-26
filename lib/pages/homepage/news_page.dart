import 'dart:async';
import 'package:flutter/material.dart';
import 'package:zagel/global/newstile.dart';
import 'package:zagel/global/news.dart';
import 'package:zagel/global/prefrences.dart';
import 'package:intl/intl.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  bool _loading = true;
  String sortByValue = 'Latest Top Hedlines';
  String timeFrameValue = 'Last day';

  @override
  void initState() {
    super.initState();
    getNews();
  }

  Future<void> getNewsByPopularity() async {
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('yyyy-MM-dd');

    to = formatter.format(now);

    switch (timeFrameValue) {
      case 'Last day':
        DateTime lastDay = now.subtract(Duration(days: 1));
        from = formatter.format(lastDay);
        break;
      case 'Last week':
        DateTime lastWeek = now.subtract(Duration(days: 7));
        from = formatter.format(lastWeek);
        break;
      case 'Last month':
        DateTime lastMonth = now.subtract(Duration(days: 30));
        from = formatter.format(lastMonth);
        break;
      default:
        DateTime defaultDate = now.subtract(Duration(days: 2));
        from = formatter.format(defaultDate);
        break;
    }

    getNewsdate();
  }

  Future<void> getNewsdate() async {
    newslist.clear();
    News newsclass = News();
    await newsclass.getNewsdate();
    setState(() {
      newslist = newsclass.news;
      _loading = false;
    });
  }

  Future<void> getNews() async {
    newslist.clear();
    News newsclass = News();
    await newsclass.getNews();
    setState(() {
      newslist = newsclass.news;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              "Zajel Feed",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.grey[800],
        elevation: 0.0,
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    DropdownButton<String>(
                      value: sortByValue,
                      onChanged: (String? newValue) {
                        setState(() {
                          sortByValue = newValue!;
                        });
                        if (sortByValue == 'Latest Top Hedlines') {
                          getNews();
                        } else if (sortByValue == 'popularity') {
                          timeFrameValue = 'Last day';
                          getNewsByPopularity();
                        }
                      },
                      style: TextStyle(color: Colors.white),
                      icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                      underline: Container(
                        height: 2,
                        color: Colors.white,
                      ),
                      items: <String>['Latest Top Hedlines', 'popularity']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    if (sortByValue == 'popularity')
                      DropdownButton<String>(
                        value: timeFrameValue,
                        onChanged: (String? newValue) {
                          setState(() {
                            timeFrameValue = newValue!;
                          });
                          getNewsByPopularity();
                        },
                        style: TextStyle(color: Colors.white),
                        icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                        underline: Container(
                          height: 2,
                          color: Colors.white,
                        ),
                        items: <String>['Last day', 'Last week', 'Last month']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: newslist.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: <Widget>[
                          NewsTile(
                            newsimgurl: newslist[index].urlToImage,
                            newstitle: newslist[index].title,
                            newsdescription: newslist[index].description,
                            newsurl: newslist[index].articleUrl,
                            newsauthor: newslist[index].newsauthor.toString(),
                          ),
                          Divider(height: 1, color: Colors.grey),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
