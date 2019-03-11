import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'dart:math';

Future fetchItem() async {
  final _random = new Random();
  int next(int min, int max) => min + _random.nextInt(max - min);
  var charId = next(1, 493);
  final response =
      await http.get('https://rickandmortyapi.com/api/character/${charId}');
  if (response.statusCode == 200) {
    return json.decode(response.body.toString());
  } else {
    throw Exception('Failed to load post');
  }
}

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future items = fetchItem();

  _fetchState() {
    setState(() {
      items = fetchItem();
    });
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Rick and Morty Characters',
      theme: new ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('Rick and Morty Characters'),
        ),
        body: new Container(
          child: new FutureBuilder(
            future: items,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return new Column(
                  children: [
                    new Padding(
                        padding: EdgeInsets.all(8.0),
                        child: new Card(
                          child: new Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              new Text('${snapshot.data['name']}',
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold)),
                              new Padding(
                                padding: EdgeInsets.all(10.0),
                                child: new ClipRRect(
                                  borderRadius:
                                      new BorderRadius.circular(1358.0),
                                  child: new Image.network(
                                      '${snapshot.data['image']}',
                                      height: 270.0),
                                ),
                              ),
                              new Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  new Column(
                                    children: <Widget>[
                                      new Chip(
                                        label: Text(
                                            'Status: ${snapshot.data['status']}',
                                            textAlign: TextAlign.center),
                                        backgroundColor: Colors.redAccent,
                                      ),
                                      new Chip(
                                        label: Text(
                                            'Species: ${snapshot.data['species']}',
                                            textAlign: TextAlign.center),
                                        backgroundColor: Colors.deepOrange,
                                      ),
                                      new Chip(
                                        label: Text(
                                            'Origin: ${snapshot.data['origin']['name']}',
                                            textAlign: TextAlign.center),
                                        backgroundColor: Colors.orange,
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              new RaisedButton(
                                onPressed: () {
                                  _fetchState();
                                },
                                child: const Text("I don't like this one!"),
                              ),
                            ],
                          ),
                        ))
                  ],
                );
              } else if (snapshot.hasError) {
                return new Text("${snapshot.error}");
              }

              // By default, show a loading spinner
              return new Center(child: new CircularProgressIndicator());
            },
          ),
        ),
      ),
    );
  }
}
