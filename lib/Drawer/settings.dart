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
                    await FirebaseAuth.instance
                        .sendPasswordResetEmail(email: userData[0]['Email']);
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.success,
                      animType: AnimType.rightSlide,
                      title: 'Requset Confirmed',
                      desc: 'Hit you\'r Email And Reset The password',
                      btnOkOnPress: () {},
                    ).show();
                  } catch (e) {
                    AwesomeDialog(
                            context: context,
                            dialogType: DialogType.error,
                            animType: AnimType.rightSlide,
                            title: 'Error',
                            desc: 'Account Doesn\'t Exists',
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
        if (isLoading)
          Positioned.fill(
            child: c,
          ),
      ],
    );
  }
}
