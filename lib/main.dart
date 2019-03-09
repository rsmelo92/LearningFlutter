import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Ricky and Morty Characters',
      theme: new ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('Ricky and Morty Characters'),
        ),
        body:new FutureBuilder<Char>(
          future: fetchChars(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              print(snapshot.data);
              return Text('asdsadsa');
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }

            // By default, show a loading spinner
            return CircularProgressIndicator();
          },
          // builder: (context, snapshot) {
          //   if (snapshot.hasData) {
          //     return ListView.builder(
          //       itemCount: snapshot.data.length,
          //       itemBuilder: (context, index) {
          //         // print('Howdy, ${snapshot.data['name']}!');
          //         print("===> ${snapshot.data}");
          //         return CardItem(snapshot.data);
          //       },
          //     );
          //   } else if (snapshot.hasError) {
          //     print(snapshot.error);
          //     return new Text("error: ${snapshot.error}");
          //   }

          //   // By default, show a loading spinner
          //   return new Center(child: new CircularProgressIndicator());
          // },
        )
        // new Container(
        //   child: new FutureBuilder<List>(
        //     future: fetchChars(),
        //     builder: (context, snapshot) {
        //       if (snapshot.hasData) {
        //         return ListView.builder(
        //           itemCount: items.length,
        //           itemBuilder: (context, index) {
        //             return ListTile(
        //               title: Text('${items[index]}'),
        //             );
        //           },
        //         );
        //       } else if (snapshot.hasError) {
        //         return new Text("${snapshot.error}");
        //       }

        //       // By default, show a loading spinner
        //       return new Center(child: new CircularProgressIndicator());
        //     },
        //   ),
        // ),
      ),
    );
  }



  Future<Char> fetchChars() async {
    final response = await http.get('https://rickandmortyapi.com/api/character/2');

    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON
      return Char.fromJson(json.decode(response.body));
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load post');
    }
    // Map<dynamic, dynamic> responseJson = json.decode(response.body.toString());
    // var chars = responseJson['results'];
    // print('==>');
    // print(chars);
    // for (var items in chars){ //iterate over the list
    //   Map myMap = items; //store each map
    //   print(myMap['name']);
    // }
    // return chars;
  }

}


class CharTile extends StatelessWidget {
  final _chat;
  CharTile(this._chat);

  @override
  Widget build(BuildContext context) => new Column(
    children: <Widget>[
      new ListTile(
        title: Text(_chat.name),
        subtitle: Text(_chat.tagline),
      ),
      Divider()
    ],
  );
}

class CardItem extends StatelessWidget {
  final _char;
  CardItem(this._char);

  @override
  Widget build(BuildContext context) {
    return  Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const ListTile(
            leading: Icon(Icons.album),
            title: Text('The Enchanted Nightingale'),
            subtitle: Text('Music by Julie Gable. Lyrics by Sidney Stein.'),
          ),
        ],
      ),
    );
  }
}

class Char {
  int id;
  String name;
  String status;
  String species;
  String type;
  String gender;

  Char({this.id, this.name, this.status, this.species, this.type, this.gender});

  factory Char.fromJson(Map<String, dynamic> json) {
    return Char(
      id: json['id'],
      name: json['name'],
      status: json['status'],
      species: json['species'],
      type: json['type'],
      gender: json['gender'],
    );
  }
}
