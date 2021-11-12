// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project_giphy/ui/gif_page.dart';
import 'package:share/share.dart';
import 'package:transparent_image/transparent_image.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String search = "";
  int offset = 0;

  Future<Map> getfile() async {
    http.Response response;
    if (search.isEmpty) {
      response = await http.get(Uri.parse(
          "https://api.giphy.com/v1/gifs/trending?api_key=oPHJa7BQLd7w1GNGGjDNoNSNnOad304z&limit=20&rating=g"));
    } else {
      response = await http.get(Uri.parse(
          "https://api.giphy.com/v1/gifs/search?api_key=oPHJa7BQLd7w1GNGGjDNoNSNnOad304z&q=$search=&limit=19&offset=$offset&rating=g&lang=en"));
    }
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Image.network(
            "https://developers.giphy.com/static/img/dev-logo-lg.gif"),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      // ignore: prefer_const_literals_to_create_immutables
      body: Column(children: [
        Padding(
          padding: EdgeInsets.all(10),
          child: TextField(
              decoration: InputDecoration(
                  label: Text("Pesquisar"),
                  labelStyle: TextStyle(color: Colors.white, fontSize: 18)),
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 18),
              onSubmitted: (text) {
                setState(() {
                  search = text;
                  offset = 0;
                });
              }),
        ),
        Expanded(
            child: FutureBuilder(
                future: getfile(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return Center(
                          child: SizedBox(
                              width: 100,
                              height: 100,
                              child: CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation(Colors.white),
                                strokeWidth: 5.0,
                              )));

                    default:
                      if (snapshot.hasError) {
                        return Text(
                          "Erro ao carregar gifs!",
                          style: TextStyle(color: Colors.white),
                        );
                      } else {
                        return getGifTable(context, snapshot);
                      }
                  }
                }))
      ]),
    );
  }

  int itemCount(List data) {
    if (search.isEmpty) {
      return data.length;
    } else {
      return data.length + 1;
    }
  }

  Widget getGifTable(BuildContext context, AsyncSnapshot snapshot) {
    return Padding(
        padding: EdgeInsets.all(10),
        child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10),
            itemCount: itemCount(snapshot.data["data"]),
            itemBuilder: (context, index) {
              if (search.isEmpty || index < snapshot.data["data"].length) {
                return GestureDetector(
                  child: FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage,
                    image: snapshot.data["data"][index]["images"]
                        ["fixed_height"]["url"],
                    height: 300,
                    fit: BoxFit.cover,
                  ),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return Gifpage(snapshot.data["data"][index]);
                    }));
                  },
                  onLongPress: () {
                    Share.share(snapshot.data["data"][index]["images"]
                        ["fixed_height"]["url"]);
                  },
                );
              } else {
                return GestureDetector(
                  child: SizedBox(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                        Icon(
                          Icons.add,
                          size: 50,
                          color: Colors.white,
                        ),
                        Text(
                          "Carregar mais...",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        )
                      ])),
                  onTap: () {
                    setState(() {
                      offset += 19;
                    });
                  },
                );
              }
            }));
  }
}
