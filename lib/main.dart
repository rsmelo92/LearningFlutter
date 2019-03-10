import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

Future fetchItem() async {
    final response = await http.get('https://www.boredapi.com/api/activity');
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
      title: 'Boredom Destroyer',
      theme: new ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('Boredom Destroyer'),
        ),
        body: new Container(
          child: new FutureBuilder(
            future: items,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return new Column(
                  children: [new Padding(
                    padding: EdgeInsets.all(8.0),
                    child: new Card(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        new Text('What should I do?', style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold)),
                        new ListTile(
                          title: Text('${snapshot.data['activity']}', textAlign: TextAlign.center),
                        ),

                        new RaisedButton(
                          onPressed: () { _fetchState(); },
                          child: const Text('Hit me up!'),
                        ),
                      ],
                    ),
                  ))],
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
