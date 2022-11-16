import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Album> fetchAlbum() async {
  final response = await http.get(Uri.parse(
      'https://lets-travel-srilanka-gyknp.ondigitalocean.app/api/videos?filters[place][id][\$eqi]=15'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Album.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

class Album {
  final int id;
  final String channel;
  final String title;

  const Album({required this.id, required this.channel, required this.title});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
        id: json['id'], channel: json['channel'], title: json['title']);
  }
}

void main() {
  runApp(MyApp());
}
//
// void getHttp() async {
//   try {
//     var response = await Dio().get(
//         'https://lets-travel-srilanka-gyknp.ondigitalocean.app/api/videos?filters[place][id][\$eqi]=15');
//     print(response);
//   } catch (e) {
//     print(e);
//   }
// }

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
                              Text(
                                "Jaffna Library",
                                style: TextStyle(fontSize: 30),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                              "Jaffna Public Library (Tamil: யாழ் பொது நூலகம்) Is Located In Jaffna, Sri Lanka. It Is One Of Jaffna's Most Notable Landmarks, And Is Run By The Jaffna Municipal Council. The Library Was Built In 1933 And Burnt In 1981. During The Early 1980s, It Was One Of The Biggest Libraries In Asia, Containing Over 97,000 Books And Manuscripts.[2][3] Over A Million Books Burned In The 1981 Arson Attack. Some Ancient Sinhala And Tamil Books Were Never Recovered. In 2001, Rehabilitation Of The Library Was Completed, With New Structures Being Built And New Books Received, Although Its Old Books And Manuscripts Were Not Replaced. It Is Sri Lanka's Second Main Public Library, Only Rivalled By Colombo Public Library"),
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
                                        return Text(snapshot.data!.title);
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
        ),
      ),
    );
  }
}
