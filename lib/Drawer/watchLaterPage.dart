import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../home/Details Page.dart';

class WatchLater extends StatefulWidget {
  const WatchLater({super.key});

  @override
  State<WatchLater> createState() => _ExState();
}

class _ExState extends State<WatchLater> {
  final CollectionReference _savedCollection =
      FirebaseFirestore.instance.collection('saved');
  bool loading = true;
  Widget c = Center(
      child: CircularProgressIndicator(
    color: Colors.amber,
  ));

  List<QueryDocumentSnapshot<Map<String, dynamic>>> wlater = [];
  Future<void> _getWlater() async {
    if (!loading) {
      setState(() {
        loading = true;
      });
    }
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection("saved")
        .where("userId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
    setState(() {
      wlater.clear();
      wlater.addAll(querySnapshot.docs);
      loading = false;
    });
  }

  @override
  void initState() {
    _getWlater();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
///////////////////////   AppBar    ///////////////////////////////
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.arrow_back_ios_new, color: Colors.amber[400])),
          title: Text(
            "Watch Later",
            style: TextStyle(color: Colors.amber),
          ),
        ),
        backgroundColor: Colors.grey[800],
///////////////////////   Body    ///////////////////////////////
        body: loading && wlater.isEmpty
            ? c
            : RefreshIndicator(
                onRefresh: _getWlater,
                color: Colors.amber,
                backgroundColor: Colors.grey[900],
                child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: (screenWidth * 0.03).clamp(4.0, 8.0),
                        vertical: (screenWidth * 0.03).clamp(8.0, 12.0)),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        if (wlater.isEmpty && !loading) {
                          return Center(
                              child: Text("No items in your watch later list.",
                                  style: TextStyle(
                                      color: Colors.white70, fontSize: 16)));
                        }
                        return Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal:
                                  (screenWidth * 0.03).clamp(12.0, 16.0)),
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              int crossAxisCount = 2;
                              if (constraints.maxWidth > 1200) {
                                crossAxisCount = 5;
                              } else if (constraints.maxWidth > 900) {
                                crossAxisCount = 4;
                              } else if (constraints.maxWidth > 600) {
                                crossAxisCount = 3;
                              }
                              //width 1000
                              double cardWidth = (constraints.maxWidth -
                                      (crossAxisCount - 1) * 16) /
                                  crossAxisCount; //238
                              double cardHeight = cardWidth / 0.65;
                              double childAspectRatio =
                                  cardWidth / (cardWidth * 1.6);

                              return GridView.builder(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: crossAxisCount,
                                        crossAxisSpacing: 16,
                                        mainAxisSpacing: 16,
                                        childAspectRatio: childAspectRatio),
                                itemCount: wlater.length, // Example count
                                itemBuilder: (context, index) {
                                  //to be Continued

                                  // Movie Card - Inlined

                                  return InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) => DetailPage(
                                                  document: wlater[index])));
                                    },
                                    child: Card(
                                      color: Colors.grey[900],
                                      clipBehavior: Clip.antiAlias,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      elevation: 4,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          Expanded(
                                              flex: 7,
                                              child: Image.network(
                                                "${wlater[index]['url']}",
                                                fit: BoxFit.cover,
                                                loadingBuilder: (context, child,
                                                    loadingProgress) {
                                                  if (loadingProgress == null)
                                                    return child;
                                                  return Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                      valueColor:
                                                          AlwaysStoppedAnimation<
                                                                  Color>(
                                                              Colors
                                                                  .amber[400]!),
                                                      value: loadingProgress
                                                                  .expectedTotalBytes !=
                                                              null
                                                          ? loadingProgress
                                                                  .cumulativeBytesLoaded /
                                                              loadingProgress
                                                                  .expectedTotalBytes!
                                                          : null,
                                                    ),
                                                  );
                                                },
                                              )),
                                          Expanded(
                                            flex: 4, // Space for text content
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  Text(
                                                    "${wlater[index]['title']}",
                                                    style: TextStyle(
                                                      fontSize: (cardWidth *
                                                              0.1)
                                                          .clamp(13.0, 18.0),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.amber[400],
                                                    ),
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 5,
                                                                vertical: 1),
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Colors.amber[800],
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(3),
                                                        ),
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            Icon(Icons.star,
                                                                color: Colors
                                                                    .white,
                                                                size: (cardWidth *
                                                                        0.08)
                                                                    .clamp(10.0,
                                                                        14.0)),
                                                            SizedBox(width: 2),
                                                            Text(
                                                              "${wlater[index]['rate']}", // Example Rating
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize:
                                                                    (cardWidth *
                                                                            0.08)
                                                                        .clamp(
                                                                            10.0,
                                                                            14.0),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      const SizedBox(width: 6),
                                                      Text(
                                                        ". ${wlater[index]['year']}",
                                                        style: TextStyle(
                                                          color: Colors.white70,
                                                          fontSize: (cardWidth *
                                                                  0.075)
                                                              .clamp(
                                                                  10.0, 14.0),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        );
                      },
                    )),
              ));
  }
}
