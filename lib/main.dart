import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:untitled4/home/homepage.dart';
import 'package:untitled4/login/signup.dart';
import 'package:untitled4/login/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:untitled4/Drawer/settings.dart';

import 'Drawer/watchLaterPage.dart';
import 'home/Details Page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie Nest',
      theme: ThemeData(
        appBarTheme: AppBarTheme(backgroundColor: Colors.black87),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: FirebaseAuth.instance.currentUser == null ? Login() : Homepage(),
      routes: {
        "login": (context) => Login(),
        "signup": (context) => Signup(),
        "homepage": (context) => Homepage(),
        "watchlater": (context) => WatchLater(),
        'settings': (context) => Settings(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
