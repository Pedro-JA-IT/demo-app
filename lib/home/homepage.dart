import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:untitled4/Drawer/contactUsPage.dart';
import 'package:untitled4/home/Details%20Page.dart';
import 'package:untitled4/search/customSearch.dart';
import 'package:untitled4/home/addEditMoviePage.dart'; // New import for AddEditMoviePage
import 'package:awesome_dialog/awesome_dialog.dart'; // Import for AwesomeDialog

class Homepage extends StatefulWidget {
  Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final PageController _pageController = PageController();
  Timer? _timer;
  int _currentPage = 0;
  List<QueryDocumentSnapshot<Map<String, dynamic>>> trending = [];
  // Corrected: userData should be a single DocumentSnapshot, not a list of QueryDocumentSnapshot
  DocumentSnapshot<Map<String, dynamic>>? userData;
  List<QueryDocumentSnapshot<Map<String, dynamic>>> movies = [];
  List<QueryDocumentSnapshot<Map<String, dynamic>>> all = [];
  Widget c = Center(
      child: CircularProgressIndicator(
    color: Colors.amber,
  ));
  bool isLoading = false;
  bool _isAdmin = false; // New variable to check admin status

  @override
  void initState() {
    super.initState();
    getUserData().then((_) {
      // Fetch user data first to determine admin status
      getData();
      _startAutoScroll();
    });
  }

  getUserData() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection("users")
          .doc(currentUser.uid)
          .get(); // Get the user's main document
      if (userDoc.exists) {
        setState(() {
          userData = userDoc; // Corrected: Assign userDoc directly
          _isAdmin = userDoc.data()?['role'] ==
              'admin'; // Set isAdmin based on role field
        });
      } else {
        // If user document doesn't exist, create it with default user role
        await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .set({
          'id': currentUser.uid,
          'userName': currentUser.displayName ?? 'N/A',
          'Email': currentUser.email ?? 'N/A',
          'role': 'user',
        });
        setState(() {
          userData =
              userDoc; // Assign the newly created (empty) DocumentSnapshot
          _isAdmin = false; // Newly created user is not an admin
        });
      }
    }
  }

  getData() async {
    // Listen for real-time updates for trending movies
    FirebaseFirestore.instance
        .collection("Movies")
        .snapshots()
        .listen((snapshot) {
      setState(() {
        trending = snapshot.docs;
        all = [
          ...trending,
          ...movies
        ]; // Update 'all' list when trending changes
      });
    });

    // Listen for real-time updates for other movies
    FirebaseFirestore.instance
        .collection("moviebody")
        .snapshots()
        .listen((snapshot) {
      setState(() {
        movies = snapshot.docs;
        all = [...trending, ...movies]; // Update 'all' list when movies change
      });
    });
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (trending.isNotEmpty) {
        if (_currentPage < trending.length - 1) {
          _currentPage++;
        } else {
          _currentPage = 0;
        }
        if (_pageController.hasClients) {
          _pageController.animateToPage(
            _currentPage,
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeIn,
          );
        }
      }
    });
  }

  Future<void> _deleteMovie(
      BuildContext context,
      QueryDocumentSnapshot<Map<String, dynamic>> document,
      String collectionName) async {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      animType: AnimType.bottomSlide,
      title: 'Delete Movie',
      desc: 'Are you sure you want to delete "${document['title']}"?',
      btnCancelOnPress: () {},
      btnOkOnPress: () async {
        setState(() {
          isLoading = true;
        });
        try {
          await FirebaseFirestore.instance
              .collection(collectionName)
              .doc(document.id)
              .delete();

          // Also remove from 'saved' collection if it exists there
          QuerySnapshot savedDocs = await FirebaseFirestore.instance
              .collection('saved')
              .where('title', isEqualTo: document['title'])
              .get();
          for (var doc in savedDocs.docs) {
            await doc.reference.delete();
          }

          if (mounted) {
            setState(() {
              isLoading = false;
            });
            AwesomeDialog(
              context: context,
              dialogType: DialogType.success,
              title: 'Success',
              desc: 'Movie deleted successfully!',
              btnOkOnPress: () {},
            ).show();
          }
        } catch (e) {
          print("Error deleting movie: $e");
          if (mounted) {
            setState(() {
              isLoading = false;
            });
            AwesomeDialog(
              context: context,
              dialogType: DialogType.error,
              title: 'Error',
              desc: 'Failed to delete movie: $e',
              btnOkOnPress: () {},
            ).show();
          }
        }
      },
      btnOkColor: Colors.red,
    ).show(); // لا تنسَ .show() هنا
  }

  void _showAdminOptions(
      BuildContext context, // هذا هو "سياق الصفحة" الصحيح الذي نريده
      QueryDocumentSnapshot<Map<String, dynamic>> document) {
    showModalBottomSheet(
      context: context, // استخدم السياق الصحيح لعرض النافذة
      backgroundColor: Colors.black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      // هنا قمنا بتغيير اسم السياق المؤقت إلى modalContext لتجنب الالتباس
      builder: (BuildContext modalContext) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.edit, color: Colors.amber),
              title: Text('Edit Movie', style: TextStyle(color: Colors.white)),
              onTap: () {
                // استخدم السياق المؤقت لإغلاق النافذة السفلية
                Navigator.pop(modalContext);
                Navigator.of(context).push(
                  // استخدم سياق الصفحة الأصلي للانتقال
                  MaterialPageRoute(
                    builder: (context) => AddEditMoviePage(
                      document: document,
                      isEditing: true,
                      collectionName:
                          trending.contains(document) ? "Movies" : "moviebody",
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.delete, color: Colors.red),
              title:
                  Text('Delete Movie', style: TextStyle(color: Colors.white)),
              onTap: () {
                // 1. أغلق النافذة السفلية باستخدام سياقها المؤقت
                Navigator.pop(modalContext);
                //to be countinued

                // 2. استدع دالة الحذف باستخدام "سياق الصفحة" الأصلي والصالح
                _deleteMovie(
                    context, // <<-- التعديل الجوهري هنا
                    document,
                    trending.contains(document) ? "Movies" : "moviebody");
              },
            ),
            SizedBox(height: 16),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  String printData(List k) {
    String result = '';
    for (int i = 0; i < k.length; i++) {
      result += k[i].toString();
      result += (i == k.length - 1) ? '.' : ', ';
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final theme = Theme.of(context); // Access theme for consistent styling
    return Scaffold(
      backgroundColor: Colors.grey[800],
      key: _scaffoldKey,
//////////////////////////////////// drawer ////////////////////////////////
      drawer: Drawer(
        backgroundColor: Colors.black,
        surfaceTintColor: Colors.amber,
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.amber[800]!, Colors.amber[600]!],
                ),
              ),
              accountName: Text(
                userData != null
                    ? userData!['userName']
                    : "Loading...", // Access data directly
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              accountEmail: Text(
                userData != null
                    ? userData!['Email']
                    : "Loading...", // Access data directly
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.black,
                child: Icon(
                  Icons.person,
                  color: Colors.amber[400],
                  size: 40,
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  ListTile(
                    leading:
                        Icon(Icons.live_tv_rounded, color: Colors.amber[400]),
                    title: const Text("Watch Later",
                        style: TextStyle(color: Colors.white)),
                    onTap: () {
                      Navigator.of(context).pushNamed('watchlater');
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.email, color: Colors.amber[400]),
                    title: const Text("Contact Us",
                        style: TextStyle(color: Colors.white)),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => const ContactUs()),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.settings, color: Colors.amber[400]),
                    title: const Text("Settings",
                        style: TextStyle(color: Colors.white)),
                    onTap: () {
                      Navigator.of(context).pushNamed('settings');
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: MaterialButton(
                      height: 50,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      color: Colors.amber[800],
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.logout, color: Colors.white),
                          SizedBox(width: 8),
                          Text("Logout", style: TextStyle(color: Colors.white)),
                        ],
                      ),
                      onPressed: () async {
                        isLoading = true;
                        await FirebaseAuth.instance.signOut();
                        GoogleSignIn googleSignIn = GoogleSignIn();
                        if (await googleSignIn.isSignedIn()) {
                          await googleSignIn.disconnect();
                        }

                        if (mounted) {
                          isLoading = false;
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            "login",
                            (Route) => false,
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
/////////////////////////appbar//////////////////////////////
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.amber[400]),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            onPressed: () {
              showSearch(
                  context: context,
                  delegate: customSearch(trending: trending, movies: movies));
            },
            icon: Icon(Icons.search, color: Colors.amber[400]),
          ),
        ],
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              "assets/barLogo.png", // Ensure this asset exists
              width: screenWidth * 0.1, // Responsive width
              height:
                  kToolbarHeight * 0.7, // Responsive height relative to AppBar
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 8),
            Text(
              "Movie Nest",
              style: TextStyle(
                color: Colors.amber,
                fontSize: screenWidth * 0.05, // Responsive font size
                fontWeight: FontWeight.bold,
              ).copyWith(
                  fontSize: (screenWidth * 0.05)
                      .clamp(18.0, 24.0)), // Clamp font size
            ),
          ],
        ),
        centerTitle: true,
      ),
////////////////////////////////// body ////////////////////////////////
      body: isLoading && trending.isEmpty && movies.isEmpty
          ? c
          : RefreshIndicator(
              onRefresh: () => getData(),
              color: Colors.amber,
              backgroundColor: Colors.grey[900],
              child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: (screenWidth * 0).clamp(0, 0)),
                  child: ListView(
                      physics: AlwaysScrollableScrollPhysics(),
                      children: [
//////////////////////////////////////Treanding//////////////////////
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.grey[850]!, Colors.grey[900]!],
                            ),
                          ),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Trending ",
                                  style: TextStyle(
                                    fontSize: (screenWidth * 0.055).clamp(
                                        20.0, 26.0), // Responsive & Clamped
                                    fontWeight: FontWeight.bold,
                                    color: Colors.amber,
                                  ),
                                ),
                                Icon(
                                  Icons.local_fire_department,
                                  color: Colors.amber,
                                )
                              ],
                            ),
                          ),
                        ),
////////////////////////// Page view///////////////////////
                        SizedBox(
                            height: screenHeight * 0.45,
                            child: PageView.builder(
                                physics: AlwaysScrollableScrollPhysics(),
                                controller: _pageController,
                                scrollDirection: Axis.horizontal,
                                itemCount: trending.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    // Added GestureDetector for long press
                                    onLongPress: _isAdmin
                                        ? () => _showAdminOptions(
                                            context,
                                            trending[
                                                index]) // Show options if admin
                                        : null,
                                    child: InkWell(
                                        child: Stack(children: [
                                          Positioned.fill(
                                              child: trending.isNotEmpty
                                                  ? Image.network(
                                                      "${trending[index]['url']}",
                                                      fit: BoxFit.cover,
                                                      loadingBuilder: (context,
                                                          child,
                                                          loadingProgress) {
                                                        if (loadingProgress ==
                                                            null) return child;
                                                        return Center(
                                                          child:
                                                              CircularProgressIndicator(
                                                            valueColor:
                                                                AlwaysStoppedAnimation<
                                                                        Color>(
                                                                    Colors.amber[
                                                                        400]!),
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
                                                      errorBuilder: (context,
                                                          error, stackTrace) {
                                                        // Display a placeholder or error message when image fails to load
                                                        return Center(
                                                          child: Icon(
                                                            Icons.error_outline,
                                                            color: Colors.red,
                                                            size: 50,
                                                          ),
                                                        );
                                                      },
                                                    )
                                                  : c),
                                          Positioned.fill(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter,
                                                  colors: [
                                                    Colors.transparent,
                                                    Colors.black
                                                        .withOpacity(0.2),
                                                    Colors.black
                                                        .withOpacity(0.9),
                                                  ],
                                                  stops: const [0.4, 0.6, 1.0],
                                                ),
                                              ),
                                            ),
                                          ),
/////////////////////////////////Title of a film////////////////////////
                                          Positioned(
                                              bottom: (screenHeight * 0.02).clamp(
                                                  64.0,
                                                  65.0), // Responsive bottom padding
                                              left: (screenWidth * 0.04).clamp(12.0,
                                                  20.0), // Responsive left padding
                                              right: (screenWidth * 0.04)
                                                  .clamp(12.0, 20.0),
                                              child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    trending.isNotEmpty
                                                        ? Text(
                                                            trending[index]
                                                                ["title"],
                                                            ///////////data should be retrived//////////
                                                            style: TextStyle(
                                                                fontSize:
                                                                    (screenWidth *
                                                                            0.07)
                                                                        .clamp(22.0, 32.0),
                                                                // Responsive & Clamped
                                                                fontWeight: FontWeight.bold,
                                                                color: Colors.amber[400],
                                                                shadows: const [
                                                                  Shadow(
                                                                      blurRadius:
                                                                          2.0,
                                                                      color: Colors
                                                                          .black,
                                                                      offset:
                                                                          Offset(
                                                                              1,
                                                                              1))
                                                                ]),
                                                          )
                                                        : c
                                                  ])),

                                          Positioned(
                                            // Position the rating and year/genre information
                                            bottom: (screenHeight * 0.02).clamp(
                                                10.0,
                                                15.0), // Responsive bottom padding
                                            left: (screenWidth * 0.04).clamp(
                                                12.0,
                                                20.0), // Responsive left padding
                                            right: (screenWidth * 0.04).clamp(
                                                12.0,
                                                20.0), // Responsive right padding
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                    height: (screenHeight *
                                                            0.01)
                                                        .clamp(6.0,
                                                            10.0)), // Responsive spacing
                                                Row(children: [
                                                  Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal:
                                                                (screenWidth *
                                                                        0.02)
                                                                    .clamp(6.0,
                                                                        10.0), // Responsive padding
                                                            vertical:
                                                                (screenHeight *
                                                                        0.005)
                                                                    .clamp(3.0,
                                                                        5.0)), // Responsive padding
                                                    decoration: BoxDecoration(
                                                      color: Colors.amber[800],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4),
                                                    ),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Icon(Icons.star,
                                                            color: Colors.white,
                                                            size: (screenWidth *
                                                                    0.04)
                                                                .clamp(14.0,
                                                                    18.0)), // Responsive icon
                                                        SizedBox(
                                                            width: (screenWidth *
                                                                    0.01)
                                                                .clamp(2.0,
                                                                    4.0)), // Responsive spacing
                                                        Text(
                                                          "${trending[index]["rate"]}", //////////data should be retrived////////
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: (screenWidth *
                                                                    0.035)
                                                                .clamp(12.0,
                                                                    16.0), // Responsive font
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ]),
                                                SizedBox(
                                                    width: (screenWidth * 0.03)
                                                        .clamp(8.0, 14.0)),
                                                Row(
                                                  children: [
                                                    Text(
                                                      "${trending[index]['year']}", //// data shuld be retrived
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize:
                                                              (screenWidth *
                                                                      0.04)
                                                                  .clamp(14.0,
                                                                      18.0), // Responsive font
                                                          shadows: const [
                                                            Shadow(
                                                                blurRadius: 1.0,
                                                                color: Colors
                                                                    .black,
                                                                offset: Offset(
                                                                    1, 1))
                                                          ]),
                                                    ),
                                                    Text(
                                                      " . ",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize:
                                                              (screenWidth *
                                                                      0.04)
                                                                  .clamp(14.0,
                                                                      18.0), // Responsive font
                                                          shadows: const [
                                                            Shadow(
                                                                blurRadius: 1.0,
                                                                color: Colors
                                                                    .black,
                                                                offset: Offset(
                                                                    1, 1))
                                                          ]),
                                                    ),
                                                    trending[index]['genre']
                                                                .runtimeType ==
                                                            List
                                                        ? Text(
                                                            printData(trending[
                                                                        index]
                                                                    ['genre']
                                                                .toList()),
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize:
                                                                    (screenWidth * 0.04).clamp(
                                                                        14.0,
                                                                        18.0), // Responsive font
                                                                shadows: const [
                                                                  Shadow(
                                                                      blurRadius:
                                                                          1.0,
                                                                      color: Colors
                                                                          .black,
                                                                      offset:
                                                                          Offset(
                                                                              1,
                                                                              1))
                                                                ]),
                                                          )
                                                        : Text(
                                                            trending[index]
                                                                ['genre'],
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize:
                                                                    (screenWidth * 0.04).clamp(
                                                                        14.0,
                                                                        18.0), // Responsive font
                                                                shadows: const [
                                                                  Shadow(
                                                                      blurRadius:
                                                                          1.0,
                                                                      color: Colors
                                                                          .black,
                                                                      offset:
                                                                          Offset(
                                                                              1,
                                                                              1))
                                                                ]),
                                                          )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          if (isLoading)
                                            Positioned.fill(
                                              child: Container(
                                                color: Colors.black
                                                    .withOpacity(0.5),
                                                child: const Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                    valueColor:
                                                        AlwaysStoppedAnimation<
                                                                Color>(
                                                            Colors.amberAccent),
                                                  ),
                                                ),
                                              ),
                                            )
                                        ]),
                                        onTap: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      DetailPage(
                                                          document: trending[
                                                              index])));
                                        }),
                                  );
                                })),

                        /////////////////// grid view begin///////////////////
                        const SizedBox(height: 16),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal:
                                  (screenWidth * 0.03).clamp(12.0, 16.0)),
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              int crossAxisCount = 2;
                              if (constraints.maxWidth > 1200) {
                                // Very large screens
                                crossAxisCount = 5;
                              } else if (constraints.maxWidth > 900) {
                                // Desktop-like
                                crossAxisCount = 4;
                              } else if (constraints.maxWidth > 600) {
                                // Tablet portrait / Large phone landscape
                                crossAxisCount = 3;
                              }
                              double cardWidth = (constraints.maxWidth -
                                      (crossAxisCount - 1) * 16) /
                                  crossAxisCount;
                              double cardHeight = cardWidth / 0.65;
                              double childAspectRatio =
                                  cardWidth / (cardWidth * 1.6);

                              return GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: crossAxisCount,
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 16,
                                  childAspectRatio:
                                      childAspectRatio, // Dynamically calculated
                                ),
                                itemCount: all.length, // Example count
                                itemBuilder: (context, index) {
                                  // Movie Card - Inlined
                                  return GestureDetector(
                                    // Added GestureDetector for long press
                                    onLongPress: _isAdmin
                                        ? () => _showAdminOptions(context,
                                            all[index]) // Show options if admin
                                        : null,
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    DetailPage(
                                                        document: all[index])));
                                      },
                                      child: Card(
                                        color: Colors.grey[900],
                                        clipBehavior: Clip.antiAlias,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        elevation: 4,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            Expanded(
                                                flex:
                                                    7, // Give more space to image
                                                child: all.isNotEmpty
                                                    ? Image.network(
                                                        "${all[index]['url']}",
                                                        fit: BoxFit.cover,
                                                        loadingBuilder: (context,
                                                            child,
                                                            loadingProgress) {
                                                          if (loadingProgress ==
                                                              null)
                                                            return child;
                                                          return Center(
                                                            child:
                                                                CircularProgressIndicator(
                                                              valueColor:
                                                                  AlwaysStoppedAnimation<
                                                                      Color>(Colors
                                                                          .amber[
                                                                      400]!),
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
                                                        errorBuilder: (context,
                                                            error, stackTrace) {
                                                          // Display a placeholder or error message when image fails to load
                                                          return Center(
                                                            child: Icon(
                                                              Icons
                                                                  .error_outline,
                                                              color: Colors.red,
                                                              size: 50,
                                                            ),
                                                          );
                                                        },
                                                      )
                                                    : c),
                                            Expanded(
                                              flex: 4, // Space for text content
                                              child: Padding(
                                                padding: const EdgeInsets.all(
                                                    8.0), // Keep padding consistent for text area
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround, // Distribute space
                                                  children: [
                                                    Text(
                                                      "${all[index]['title']}", // Example title
                                                      style: TextStyle(
                                                        fontSize: (cardWidth *
                                                                0.1)
                                                            .clamp(13.0,
                                                                18.0), // Responsive based on card width
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            Colors.amber[400],
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
                                                            color: Colors
                                                                .amber[800],
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        3),
                                                          ),
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              Icon(Icons.star,
                                                                  color: Colors
                                                                      .white,
                                                                  size: (cardWidth *
                                                                          0.08)
                                                                      .clamp(
                                                                          10.0,
                                                                          14.0)),
                                                              SizedBox(
                                                                  width: 2),
                                                              Text(
                                                                "${all[index]['rate']}", // Example Rating
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: (cardWidth *
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
                                                        const SizedBox(
                                                            width: 6),
                                                        Text(
                                                          ". ${all[index]['year']}", // Example Year
                                                          style: TextStyle(
                                                            color:
                                                                Colors.white70,
                                                            fontSize:
                                                                (cardWidth *
                                                                        0.075)
                                                                    .clamp(10.0,
                                                                        14.0),
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
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ]))),
      floatingActionButton: _isAdmin
          ? FloatingActionButton(
              // Show FAB only if admin
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AddEditMoviePage(
                        isEditing: false))); // Navigate to add movie page
              },
              backgroundColor: Colors.amber[800],
              child: Icon(Icons.add, color: Colors.white),
              tooltip: 'Add New Movie',
            )
          : null,
    );
  }
}
