import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:untitled4/home/Details%20Page.dart';
import 'package:untitled4/home/homepage.dart';

class customSearch extends SearchDelegate {
  final List trending;
  final List movies;

  @override
  ThemeData appBarTheme(BuildContext context) {
    // TODO: implement appBarTheme
    return ThemeData(
        scaffoldBackgroundColor: Colors.black,
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: TextStyle(
              color: Colors.amber[300]), // Set hint text color to amber
        ),
        textTheme: TextTheme(
          titleLarge:
              TextStyle(color: Colors.white), // Set input text color to amber
        ),
        appBarTheme: AppBarTheme(color: Colors.black));
  }

  customSearch({required this.trending, required this.movies});

  @override
  List<Widget>? buildActions(BuildContext context) {
    // TODO: implement buildActions
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: Icon(
            Icons.close,
            color: Colors.red,
          ))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: Icon(
          Icons.arrow_back,
          color: Colors.amber,
        ));
  }

  @override
  Widget buildResults(BuildContext context) {
    List searchResults = [];

    searchResults.addAll(trending.where((movie) =>
        (movie['title']?.toLowerCase().contains(query.toLowerCase()) ??
            false)));

    searchResults.addAll(movies.where((movie) =>
        (movie['title']?.toLowerCase().contains(query.toLowerCase()) ??
            false)));

    searchResults = searchResults.toSet().toList();

    return Container(
      color: Colors.black,
      child: ListView.builder(
        itemCount: searchResults.length,
        itemBuilder: (context, index) {
          final movie = searchResults[index];
          return Card(
            color: Colors.grey[800],
            child: ListTile(
              trailing: Image.network(
                movie['url'],
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
              title: Text(
                movie['title'] ?? 'No Title',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                // Navigate to DetailPage with the selected movie object
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => DetailPage(
                        document: movie
                            as QueryDocumentSnapshot<Map<String, dynamic>>)));
              },
            ),
          );
        },
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List suggestionList = [];

    if (query == '') {
      suggestionList.addAll(trending.where(
          (movie) => ((num.tryParse(movie['rate'].toString())) ?? 0) > 8));
      suggestionList.addAll(movies.where(
          (movie) => ((num.tryParse(movie['rate'].toString())) ?? 0) > 8));
      suggestionList = suggestionList.toSet().toList();
    } else {
      suggestionList.addAll(trending.where((movie) =>
          (movie['title']?.toLowerCase().contains(query.toLowerCase()) ??
              false)));
      suggestionList.addAll(movies.where((movie) =>
          (movie['title']?.toLowerCase().contains(query.toLowerCase()) ??
              false)));
      suggestionList = suggestionList.toSet().toList();
    }

    return Container(
      color: Colors.black,
      child: ListView.builder(
          itemCount: suggestionList.length,
          itemBuilder: (context, index) {
            final movie = suggestionList[index];
            return Card(
              margin: EdgeInsets.all(10),
              color: Colors.grey[800],
              child: ListTile(
                onTap: () {
                  //query = movie['title'] ?? '';
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => DetailPage(
                          document: movie
                              as QueryDocumentSnapshot<Map<String, dynamic>>)));
                },
                //to be continued ...
                trailing: Image.network(
                  movie['url'],
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
                title: Text(
                  movie['title'] ?? 'No Title',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            );
          }),
    );
  }
}
