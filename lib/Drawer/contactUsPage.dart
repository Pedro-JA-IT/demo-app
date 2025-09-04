import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUs extends StatelessWidget {
  const ContactUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber[100],
      appBar: AppBar(
        title: Text(
          "Contact Us",
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
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          GestureDetector(
            onTap: () async {
              final Uri emailLaunchUri = Uri(
                scheme: 'mailto',
                path: 'safegalek15@gmail.com',
              );
              if (await canLaunchUrl(emailLaunchUri)) {
                await launchUrl(emailLaunchUri);
              }
            },
            child: Card(
              elevation: 2,
              color: Colors.white,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.amber[600],
                  child: Text("1", style: TextStyle(color: Colors.white)),
                ),
                title: Text("Ibrahim Jamous",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text("safegalek15@gmail.com",
                    //to be continued..
                    style: TextStyle(color: Colors.grey[600])),
              ),
            ),
          ),
          SizedBox(height: 8),
          GestureDetector(
            onTap: () async {
              final Uri emailLaunchUri = Uri(
                scheme: 'mailto',
                path: 'Xxxxx@gmail.com',
              );
              if (await canLaunchUrl(emailLaunchUri)) {
                await launchUrl(emailLaunchUri);
              }
            },
            child: Card(
              elevation: 2,
              color: Colors.white,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.amber[600],
                  child: Text("2", style: TextStyle(color: Colors.white)),
                ),
                title: Text("Ibrahim Alkhayer",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text("Xxxxx@gmail.com",
                    style: TextStyle(color: Colors.grey[600])),
              ),
            ),
          ),
          SizedBox(height: 8),
          GestureDetector(
            onTap: () async {
              final Uri emailLaunchUri = Uri(
                scheme: 'mailto',
                path: 'Xxxxx@gmail.com',
              );
              if (await canLaunchUrl(emailLaunchUri)) {
                await launchUrl(emailLaunchUri);
              }
            },
            child: Card(
              elevation: 2,
              color: Colors.white,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.amber[600],
                  child: Text("3", style: TextStyle(color: Colors.white)),
                ),
                title: Text("Mahmoud Alkhansaa",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text("Xxxxx@gmail.com",
                    style: TextStyle(color: Colors.grey[600])),
              ),
            ),
          )
        ],
      ),
    );
  }
}
