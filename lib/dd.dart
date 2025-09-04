import 'package:flutter/material.dart';

class Custom extends SearchDelegate {
  List movies = ['caca', 'mongols'];
  List? filter;

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: Icon(Icons.close))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    return Text("hush hush");
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query == '') {
      return ListView.builder(
        itemBuilder: (context, i) {
          return Card(
              child: Padding(
            padding: const EdgeInsets.all(15),
            child: Text(movies[i]),
          ));
        },
        itemCount: movies.length,
      );
    } else {
      filter = movies.where((element) => element.contains(query)).toList();
      return ListView.builder(
        itemBuilder: (context, i) {
          return Card(child: Text("${filter![i]}"));
        },
        itemCount: filter!.length,
      );
    }
  }
}
