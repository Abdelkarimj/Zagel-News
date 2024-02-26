import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zagel/pages/LoginOrRegester_page.dart';
import 'package:zagel/pages/home_page.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          //if loged in
          if (snapshot.hasData) {
            return HomePage();
            //if not
          } else {
            return LoginOrRegesterPage();
          }
        },
      ),
    );
  }
}
