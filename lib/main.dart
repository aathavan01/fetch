import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Album> fetchAlbum() async {
  final response = await http.get(Uri.parse(
      'https://lets-travel-srilanka-gyknp.ondigitalocean.app/api/places?populate[image][fields][0]=url&populate=town&filters[slug][\$eq]=jaffna-library'));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body)["data"][0]["attributes"];
    final title = data["title"];
    final description = data["description"];
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Album(title: title, description: description);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

class Album {
  // final int userId;
  // final int id;
  final String title;
  final String description;

  const Album(
      {
      //   required this.userId,
      // required this.id,
      required this.title,
      required this.description});

  // factory Album.fromJson(Map<String, dynamic> json) {
  //   return Album(
  //     userId: json['userId'],
  //     id: json['id'],
  //     title: json['title'],
  //     desc: json['body'],
  //   );
  // }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<Album> futureAlbum;

  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum();
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "appbar",
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: SizedBox(
              height: 50,
              width: 100,
               child: Image.asset("images/logo22.png", fit: BoxFit.cover),
            ),
            backgroundColor: Colors.white,
            actions: [
              IconButton(
                onPressed: () {
                  fetchAlbum();
                },
                icon: Icon(Icons.menu_open_outlined),
                color: Colors.black,
              )
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 30,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 20,
                              ),
                              FutureBuilder<Album>(
                                future: futureAlbum,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return Text(snapshot.data!.title);
                                  } else if (snapshot.hasError) {
                                    return Text('${snapshot.error}');
                                  }

                                  // By default, show a loading spinner.
                                  return const CircularProgressIndicator();
                                },
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          FutureBuilder<Album>(
                            future: futureAlbum,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Text(snapshot.data!.description);
                              } else if (snapshot.hasError) {
                                return Text('${snapshot.error}');
                              }

                              // By default, show a loading spinner.
                              return const CircularProgressIndicator();
                            },
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          SizedBox(
                            height: 400,
                            width: 800,
                             child: Image.asset("images/jaffna.jpg",
                                 fit: BoxFit.cover),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  child: Column(
                    children: <Widget>[
                      DefaultTabController(
                        length: 3, // length of tabs
                        initialIndex: 0,
                        child: Column(
                          children: <Widget>[
                            Container(
                              child: TabBar(
                                labelColor: Colors.black,
                                unselectedLabelColor: Colors.black,
                                tabs: [
                                  Tab(text: 'All'),
                                  Tab(
                                    text: 'Videos',
                                  ),
                                  Tab(text: 'Blogs'),
                                ],
                              ),
                            ),
                            Container(
                              height: 400, //height of TabBarView

                              child: TabBarView(children: <Widget>[
                                Container(
                                  child: Center(
                                    child: Text('Display Tab 1',
                                        style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ),
                                Container(
                                  child: FutureBuilder<Album>(
                                    future: futureAlbum,
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return ListView.builder(
                                          itemCount: 10,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return Column(
                                              children: [
                                                Text(snapshot.data!.title)
                                              ],
                                            );
                                          },
                                        );
                                      } else if (snapshot.hasError) {
                                        return Text('${snapshot.error}');
                                      }

                                      // By default, show a loading spinner.
                                      return const CircularProgressIndicator();
                                    },
                                  ),
                                ),
                                Container(
                                  child: Center(
                                    child: Text('Display Tab 3',
                                        style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ),
                              ]),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),),);
    

}}