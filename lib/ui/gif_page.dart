import 'package:flutter/material.dart';
import 'package:share/share.dart';

class Gifpage extends StatelessWidget {
  final Map gifData;

  // ignore: use_key_in_widget_constructors
  const Gifpage(this.gifData);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.black,
            title: Text(gifData["title"]),
            actions: [
              IconButton(
                onPressed: () {
                  Share.share(gifData["images"]["fixed_height"]["url"]);
                },
                icon: const Icon(Icons.share),
              )
            ]),
        backgroundColor: Colors.black,
        body: Center(
            child: Image.network(gifData["images"]["fixed_height"]["url"])));
  }
}
