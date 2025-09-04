import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ContactUs extends StatelessWidget {
  const ContactUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.purpleAccent,
        ),
        body: Column(
          children: [
            Gard(name: "pedro", email: "Xxxx@gamil.com", i: "1"),
            Gard(name: "hema", email: "Xxxx@gamil.com", i: "2"),
            Gard(name: "conca", email: "Xxxx@gamil.com", i: "3")
          ],
        ));
  }
}

class Gard extends StatelessWidget {
  final String i;
  final String name;
  final String email;
  const Gard(
      {super.key, required this.name, required this.email, required this.i});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      shadowColor: Colors.purpleAccent,
      color: Colors.grey,
      margin: EdgeInsets.only(top: 10, left: 10, right: 10),
      child: ListTile(
        leading: Text("$i"),
        title: Text("$name"),
        subtitle: Text("$email"),
        // contentPadding:
        //   EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      ),
    );
  }
}
