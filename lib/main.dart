import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:zagel/firebase_options.dart';
import 'package:zagel/notifications/firebaseAPI.dart';

import 'package:zagel/pages/authcheck_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize and use the NotificationManager
  NotificationManager notificationManager = NotificationManager();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return const AuthPage();
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
