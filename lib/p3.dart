import 'package:flutter/material.dart';

void main() {
  runApp(test());
}

class test extends StatefulWidget {
  test({super.key});

  @override
  _KKm createState() => _KKm();
}

class _KKm extends State<StatefulWidget> {
  int i = 0;
  bool n = true;
  var k = Icon(Icons.star);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            body: Column(children: [
      IconButton(
          padding: EdgeInsets.all(50),
          onPressed: () {
            if (n) {
              n = false;
              setState(() {
                k = Icon(Icons.star_outline);
              });
            } else {
              n = true;
              setState(() {
                k = Icon(Icons.star);
              });
            }
          },
          icon: k)
    ])));
  }
}
