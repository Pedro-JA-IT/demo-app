import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({
    super.key,
    required this.document,
  });
  final QueryDocumentSnapshot<Map<String, dynamic>> document;

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late Map<String, dynamic> movieDataFromWidget;
  bool _isCurrentlySaved = false;
  bool _isLoadingSaveStatus = true;
  String? _currentUserId;

  final CollectionReference _savedCollection =
      FirebaseFirestore.instance.collection('saved');

  @override
  void initState() {
    super.initState();
    movieDataFromWidget = Map<String, dynamic>.from(widget.document.data()!);
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      _currentUserId = currentUser.uid;
      _checkIfMovieIsSaved();
    } else {
      if (mounted) {
        setState(() {
          _isLoadingSaveStatus = false;
        });
      }
    }
  }

  Future<void> _checkIfMovieIsSaved() async {
    if (!mounted || _currentUserId == null) return;
    setState(() {
      _isLoadingSaveStatus = true;
    });
    try {
      final String movieIdentifier = movieDataFromWidget['title'];

      QuerySnapshot querySnapshot = await _savedCollection
          .where('userId', isEqualTo: _currentUserId)
          .where('title', isEqualTo: movieIdentifier)
          .limit(1)
          .get();

      if (mounted) {
        setState(() {
          _isCurrentlySaved = querySnapshot.docs.isNotEmpty;
          _isLoadingSaveStatus = false;
        });
      }
    } catch (e) {
      print("Error checking if movie is saved: $e");
      if (mounted) {
        setState(() {
          _isCurrentlySaved = false;
          _isLoadingSaveStatus = false;
        });
      }
    }
  }

  Future<void> _toggleSaveStatus() async {
    if (_currentUserId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You must be logged in to save movies.')),
      );
      return;
    }

    if (mounted) {
      setState(() {
        _isCurrentlySaved = !_isCurrentlySaved;
      });
    }

    final String movieIdentifier = movieDataFromWidget['title'];

    try {
      if (!_isCurrentlySaved) {
        QuerySnapshot querySnapshot = await _savedCollection
            .where('userId', isEqualTo: _currentUserId)
            .where('title', isEqualTo: movieIdentifier)
            .get();

        for (var doc in querySnapshot.docs) {
          await _savedCollection.doc(doc.id).delete();
        }
        print("Movie '$movieIdentifier' unsaved.");
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Removed from Watchlist: $movieIdentifier')),
          );
        }
      } else {
        Map<String, dynamic> dataToSave = {
          'userId': _currentUserId,
          'title': movieDataFromWidget['title'],
          'url': movieDataFromWidget['url'],
          'year': movieDataFromWidget['year'],
          'rate': movieDataFromWidget['rate'],
          'description': movieDataFromWidget['description'],
          'director': movieDataFromWidget['director'],
          'star': movieDataFromWidget['star'],
          'genre': movieDataFromWidget['genre'],
          'duration': movieDataFromWidget['duration'],
          'savedAt': FieldValue.serverTimestamp(),
        };
        await _savedCollection.add(dataToSave);
        print("Movie '$movieIdentifier' saved.");
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Added to Watchlist: $movieIdentifier')),
          );
        }
      }
    } catch (e) {
      print("Error toggling save status for '$movieIdentifier': $e");
      if (mounted) {
        setState(() {
          _isCurrentlySaved = !_isCurrentlySaved;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Failed to update watchlist. Please try again.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final swidth = MediaQuery.of(context).size.width;
    final sheight = MediaQuery.of(context).size.height;
    final data = widget.document.data();
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.5),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.amber[400]),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Movie Details',
          style: TextStyle(color: Colors.amber[400]),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 400,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(data['url'] ??
                      'https://via.placeholder.com/400x600?text=No+Image'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.7),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: sheight * 0.02,
                    left: swidth * 0.04,
                    right: swidth * 0.04,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FittedBox(
                          child: Text(
                            data['title'] ?? 'No Title',
                            style: theme.textTheme.headlineMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              shadows: const [
                                Shadow(
                                  color: Colors.black,
                                  blurRadius: 10,
                                  offset: Offset(2, 2),
                                )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.amber[800],
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.star,
                                      color: Colors.white, size: 16),
                                  const SizedBox(width: 4),
                                  Text(
                                    data['rate']?.toString() ?? 'N/A',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              ".",
                              style: TextStyle(color: Colors.white),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              data['year']?.toString() ?? '',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: sheight * 0.01,
                    right: swidth * 0.054,
                    child: Row(
                      children: [
                        _isLoadingSaveStatus
                            ? const SizedBox(
                                width: 30,
                                height: 30,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2, color: Colors.amber),
                              )
                            : IconButton(
                                onPressed: _toggleSaveStatus,
                                icon: Icon(
                                  _isCurrentlySaved
                                      ? Icons.bookmark
                                      : Icons.bookmark_outline_sharp,
                                  color: Colors.amber,
                                  size: 30,
                                ),
                                tooltip: _isCurrentlySaved
                                    ? 'Remove from Watchlist'
                                    : 'Add to Watchlist',
                              ),
                        const SizedBox(width: 10),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.share,
                            color: Colors.amber,
                            size: 30,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Storyline',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber[400],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    data['description'] ?? 'No description available.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[300],
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 25),
                  Text(
                    'Details',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber[400],
                    ),
                  ),
                  const SizedBox(height: 15),
                  _buildDetailRow(
                    icon: Icons.person,
                    label: 'Director',
                    value: data['director'] ?? 'N/A',
                  ),
                  const SizedBox(height: 10),

                  // ## التعديل رقم 1: معالجة حقل "star" بشكل آمن
                  _buildDetailRow(
                    icon: Icons.people,
                    label: 'Stars',
                    value: data['star'] is List
                        ? (data['star'] as List<dynamic>).join(', ')
                        : data['star']?.toString() ?? 'N/A',
                  ),
                  const SizedBox(height: 10),

                  _buildDetailRow(
                    icon: Icons.category,
                    label: 'Genre',
                    value: data['genre'] is List
                        ? (data['genre'] as List<dynamic>).join(', ')
                        : data['genre']?.toString() ?? 'N/A',
                  ),
                  const SizedBox(height: 10),
                  _buildDetailRow(
                    icon: Icons.timer,
                    label: 'Duration',
                    value: data['duration']?.toString() ?? 'N/A',
                  ),
                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      // ## التعديل رقم 2: معالجة رابط "trailerUrl" بشكل آمن
                      onPressed: () async {
                        final trailerUrlString = data['trailerUrl'];
                        if (trailerUrlString != null &&
                            trailerUrlString.isNotEmpty) {
                          final Uri url = Uri.parse(trailerUrlString);
                          if (!await launchUrl(url)) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text('Could not launch $url')));
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('No trailer available.')));
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber[800],
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'WATCH Trailer',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.amber[400], size: 24),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[400],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
