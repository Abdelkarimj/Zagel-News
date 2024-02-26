import 'package:flutter/material.dart';
import 'package:zagel/global/prefrences.dart';
import 'package:firebase_auth/firebase_auth.dart';

String selectedCountry = "English";

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Future<void> reauthenticateUser(String currentPassword) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );

      try {
        await user.reauthenticateWithCredential(credential);
      } catch (error) {
        print("Reauthentication failed: $error");
        // Handle reauthentication failure
        throw error;
      }
    }
  }

  void countryselected(String selectedcontry) {
    if (selectedCountry == "Arabic") {
      language = "ar";
    } else if (selectedCountry == "German") {
      language = "de";
    } else if (selectedCountry == "English") {
      language = "en";
    } else if (selectedCountry == "Spanish") {
      language = "es";
    } else if (selectedCountry == ("French")) {
      language = "fr";
    } else if (selectedCountry == ("Hindi")) {
      language = "hi";
    } else if (selectedCountry == ("Italian")) {
      language = "it";
    } else if (selectedCountry == ("Japanese")) {
      language = "ja";
    } else if (selectedCountry == ("Dutch")) {
      language = "nl";
    } else if (selectedCountry == ("Norwegian")) {
      language = "no";
    } else if (selectedCountry == ("Polish")) {
      language = "pl";
    } else if (selectedCountry == ("Portuguese")) {
      language = "pt";
    } else if (selectedCountry == ("Russian")) {
      language = "ru";
    } else if (selectedCountry == ("Swedish")) {
      language = "sv";
    } else if (selectedCountry == ("Turkish")) {
      language = "tr";
    } else if (selectedCountry == ("Chinese")) {
      language = "zh";
    } else {
      language = "en";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Settings",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: Colors.grey[800],
      ),
      body: Container(
        color: Colors.grey[900],
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image(
                image: AssetImage('lib/images/Zajel.png'),
                alignment: Alignment.center,
                height: 280,
              ),
              ListTile(
                title: Text(
                  'Logout',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  FirebaseAuth.instance.signOut();
                },
              ),
              Divider(color: Colors.white),
              ListTile(
                title: Text(
                  'Change Password',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () async {
                  TextEditingController passwordController =
                      TextEditingController();
                  TextEditingController currentPasswordController =
                      TextEditingController();

                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Enter new password'),
                        content: Container(
                          height: MediaQuery.of(context).size.height * 0.3,
                          child: Column(
                            children: [
                              TextField(
                                controller: passwordController,
                                decoration:
                                    InputDecoration(hintText: "New password"),
                                obscureText: true,
                              ),
                              TextField(
                                controller: currentPasswordController,
                                decoration: InputDecoration(
                                    hintText: "Current password"),
                                obscureText: true,
                              ),
                            ],
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: Text('Submit'),
                            onPressed: () async {
                              String newPassword = passwordController.text;
                              String currentPassword =
                                  currentPasswordController.text;

                              try {
                                await reauthenticateUser(currentPassword);

                                User? user = FirebaseAuth.instance.currentUser;
                                if (user != null) {
                                  await user
                                      .updatePassword(newPassword)
                                      .then((_) {
                                    print("Successfully changed password");
                                    Navigator.of(context).pop();
                                  }).catchError((error) {
                                    print("Failed to change password: $error");
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                "Failed to change password: $error")));
                                  });
                                }
                              } catch (error) {
                                // Handle reauthentication failure
                                print("Reauthentication failed: $error");
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          "Reauthentication failed: $error")),
                                );
                              }
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              Divider(color: Colors.white),
              Text(
                'Change News Language:',
                style: TextStyle(color: Colors.white),
              ),
              DropdownButton<String>(
                value: selectedCountry,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedCountry = newValue!;
                    countryselected(selectedCountry);
                    // Update global value
                  });
                },
                style: TextStyle(color: Colors.white),
                icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                underline: Container(
                  height: 2,
                  color: Colors.white,
                ),
                items: [
                  'Arabic',
                  'German',
                  'English',
                  'Spanish',
                  'French',
                  'Hindi',
                  'Italian',
                  'Japanese',
                  'Dutch',
                  'Norwegian',
                  'Polish',
                  'Portuguese',
                  'Russian',
                  'Swedish',
                  'Turkish',
                  'Chinese',
                ].map<DropdownMenuItem<String>>((String value) {
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
              Divider(color: Colors.white),
              /*ListTile(
                title: Text(
                  'History',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  //HistoryPage();
                },
              ),*/
              Divider(color: Colors.white),
              Container(
                alignment: Alignment.center,
                child: const Text(
                  "Zajel News @2023 - GJU\nDevolped by Abdelkarim Alghayyath",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
