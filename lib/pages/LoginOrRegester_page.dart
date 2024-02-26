import 'package:flutter/material.dart';
import 'package:zagel/pages/login_page.dart';
import 'package:zagel/pages/regester_page.dart';

class LoginOrRegesterPage extends StatefulWidget {
  const LoginOrRegesterPage({super.key});

  @override
  State<LoginOrRegesterPage> createState() => _LoginOrRegesterPageState();
}

class _LoginOrRegesterPageState extends State<LoginOrRegesterPage> {
  //Show the Login Page at firist
  bool showLoginPage = true;

  //toggle between the login and regester page
  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginPage(onTap: togglePages);
    } else {
      return RegisterPage(onTap: togglePages);
    }
  }
}
