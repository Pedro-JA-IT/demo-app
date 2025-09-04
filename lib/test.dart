import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled4/ssd.dart';

import 'dd.dart';

class test extends StatefulWidget {
  const test({super.key});

  @override
  State<test> createState() => _testState();
}

GlobalKey<ScaffoldState> sca = GlobalKey();

class _testState extends State<test> with SingleTickerProviderStateMixin {
  TabController? key1;
  @override
  void initState() {
    key1 = TabController(length: 2, vsync: this);
    super.initState();
  }

  List<Widget> img = [
    Image.asset("assets/ii.jpeg"),
    Image.asset("assets/ii.jpeg"),
  ];
  List<Widget> widg = [
    Text(
      "page 1",
      style: TextStyle(
          fontWeight: FontWeight.bold, fontSize: 50, color: Colors.black),
    ),
    Text(
      "page 2",
      style: TextStyle(
          fontWeight: FontWeight.bold, fontSize: 50, color: Colors.black),
    )
  ];
  int k = 0;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          bottomNavigationBar: BottomNavigationBar(
              selectedLabelStyle: TextStyle(color: Colors.red),
              unselectedLabelStyle: TextStyle(color: Colors.white),
              selectedFontSize: 20,
              unselectedItemColor: Colors.white,
              selectedItemColor: Colors.red,
              backgroundColor: Colors.purple,
              onTap: (val) {
                setState(() {
                  k = val;
                });
              },
              currentIndex: k,
              items: [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.local_fire_department_outlined),
                    label: "Most Recent")
              ]),
          appBar: AppBar(
            backgroundColor: Colors.purple,
            shadowColor: Colors.pinkAccent,
            elevation: 10,
            bottom: TabBar(
                controller: key1,
                indicatorColor: Colors.red,
                indicatorWeight: 5,
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: Colors.redAccent,
                labelStyle: TextStyle(color: Colors.redAccent),
                unselectedLabelColor: Colors.grey,
                unselectedLabelStyle: TextStyle(color: Colors.grey),
                tabs: [
                  Tab(
                    icon: Icon(Icons.laptop),
                    text: "Laptop",
                  ),
                  Tab(
                    text: "Mobile",
                    icon: Icon(Icons.mobile_friendly_outlined),
                  )
                ]),
            centerTitle: true,
            title: Text("Central BCD"),
            leading: IconButton(
                onPressed: () {
                  sca.currentState!.openDrawer();
                },
                icon: Icon(Icons.menu)),
            actions: [
              IconButton(
                  onPressed: () {
                    showSearch(context: context, delegate: Custom());
                  },
                  icon: Icon(Icons.search))
            ],
          ),
          key: sca,
          drawer: Drawer(
            child: ListView(
              children: [
                Row(
                  children: [
                    ClipRRect(
                      child: Image.asset(
                        'assets/ii.jpeg',
                        height: 60,
                        width: 60,
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(360),
                    ),
                    Expanded(
                        child: ListTile(
                      title: Text("pedro"),
                      subtitle: Text("xxxx@gmail.com"),
                    ))
                  ],
                ),
                ListTile(
                  onTap: () {
                    print("pedo");
                  },
                  onLongPress: () {
                    print("object");
                  },
                  leading: Icon(Icons.settings),
                  title: Text("Setting"),
                ),
                Expanded(
                    child: ListTile(
                  leading: Icon(Icons.manage_accounts_outlined),
                  title: Text("Account"),
                )),
                Expanded(
                    child: ListTile(
                  leading: Icon(Icons.contact_mail),
                  title: Text("Contact us"),
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => ContactUs()));
                  },
                )),
              ],
            ),
          ),
          //\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
          body: PageView.builder(
            onPageChanged: (val) {
              if (val == img.length) {
                val = 0;
              }
            },
            itemCount: img.length,
            itemBuilder: (con, i) {
              return Column(
                children: [
                  Container(
                    child: img[i],
                    height: 100,
                  ),
                  Text("${i + 1} / ${img.length}"),
                  MaterialButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  actionsPadding:
                                      EdgeInsets.only(right: 15, left: 15),
                                  content: Text("u sure"),
                                  contentPadding:
                                      EdgeInsets.only(left: 24, top: 10),
                                  title: Text("Warning"),
                                  titlePadding:
                                      EdgeInsets.only(top: 5, left: 15),
                                  elevation: 50,
                                  shadowColor: Colors.purpleAccent,
                                  actions: [
                                    Icon(Icons.check),
                                    Icon(Icons.not_interested)
                                  ],
                                  titleTextStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w800),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(0)),
                                ));
                      },
                      child: Text("tap"),
                      textColor: Colors.white,
                      color: Colors.red)
                ],
              );
            },
          )),
    );
  }
}
