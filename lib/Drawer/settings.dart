import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool isLoading = false;
  Widget c = Container(
    width: double.infinity,
    height: double.infinity,
    color: Colors.black.withOpacity(0.7),
    child: const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.amberAccent),
      ),
    ),
  );
  List<QueryDocumentSnapshot<Map<String, dynamic>>> userData = [];
  getUserData() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      isLoading = true;
      final user = await FirebaseFirestore.instance
          .collection("users")
          .doc(currentUser.uid)
          .collection('userInfo')
          .limit(1) // Assuming uid is unique, limit to 1 document
          .get();
      isLoading = false;
      if (user.docs.isNotEmpty) {
        setState(() => userData = user.docs);
      }
    }
  }

  @override
  initState() {
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
            backgroundColor: Colors.amber[100],
            appBar: AppBar(
              title: Text(
                "Settings",
                style: TextStyle(color: Colors.amber),
              ),
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.amber,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              backgroundColor: Colors.black,
              elevation: 4,
            ),
            body: ListView(padding: EdgeInsets.all(16), children: [
              InkWell(
                onTap: () async {
                  try {
                    setState(() {
                      isLoading = true;
                    });
                    final user = FirebaseAuth.instance.currentUser;
                    if (user == null || user.email == null) return;
                    await FirebaseAuth.instance
                        .sendPasswordResetEmail(email: user.email!);
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.success,
                      animType: AnimType.rightSlide,
                      title: 'Requset Confirmed',
                      desc: 'Hit you\'r Email And Reset The password',
                      btnOkOnPress: () {
                        Navigator.of(context).pop();
                      },
                    ).show();
                  } on FirebaseAuthException catch (e) {
                    // Specific error handling for different firebase auth errors
                    String errorMessage =
                        'An error occurred. Please try again.';
                    if (e.code == 'user-not-found') {
                      errorMessage = 'Account Doesn\'t Exist.';
                    }
                    AwesomeDialog(
                            context: context,
                            dialogType: DialogType.error,
                            animType: AnimType.rightSlide,
                            title: 'Error',
                            desc: errorMessage,
                            btnOkOnPress: () {},
                            btnOkColor: Colors.orange)
                        .show();
                  }
                  setState(() {
                    isLoading = false;
                  });
                },
                child: Card(
                    elevation: 2,
                    color: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(Icons.lock),
                          Container(
                            width: 35,
                          ),
                          Text(
                            'Change Password',
                            style: TextStyle(color: Colors.black),
                          )
                        ],
                      ),
                    )),
              ),
            ])),
      ],
    );
  }
}
