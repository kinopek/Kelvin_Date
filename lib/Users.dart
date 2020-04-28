import 'dart:async';
import 'dart:collection';
//import 'dart:html';
import 'dart:math' show Random, asin, cos, min, sqrt;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
//import 'package:english_words/english_words.dart';
import 'package:geocoder/geocoder.dart';
import 'package:firebase_database/firebase_database.dart';
import 'fire.dart';
import 'package:flutter/widgets.dart';

var total = 105;
var pageSize = 20;

var completers = new List<Completer<Item>>();

class Item {
  int id;
  String name;

  Item({this.id, this.name});
}

Future<List<Item>> _loadItems(int offset, int limit) {
  var random = new Random();
  return Future.delayed(new Duration(seconds: 2 + random.nextInt(3)), () {
    return List.generate(limit, (index) {
      var id = offset + index;
      return new Item(id: id, name: "Ewaryst nr $id");
    });
  });
}



Widget _loadItem(int itemIndex) {
  if (itemIndex >= completers.length) {
    int toLoad = min(total - itemIndex, pageSize);
    completers.addAll(List.generate(toLoad, (index) {
      return new Completer();
    }));
    _loadItems(itemIndex, toLoad).then((items) {
      items.asMap().forEach((index, item) {
        completers[itemIndex + index].complete(item);
      });
    }).catchError((error) {
      completers.sublist(itemIndex, itemIndex + toLoad).forEach((completer) {
        completer.completeError(error);
      });
    });
  }

  var future = completers[itemIndex].future;
  return new FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return new Container(
              padding: const EdgeInsets.all(8.0),
              child: new Placeholder(fallbackHeight: 100.0),
            );
          case ConnectionState.done:
            if (snapshot.hasData) {
              return _generateItem(snapshot.data);
            } else if (snapshot.hasError) {
              return new Text(
                '${snapshot.error}',
                style: TextStyle(color: Colors.red),
              );
            }
            return new Text('');
          default:
            return new Text('');
        }
      });
}

Widget _generateItem(Item item) {
  return new Container(
    padding: const EdgeInsets.all(8.0),
    child: new Row(
      children: <Widget>[
        new Image.network(
          'http://via.placeholder.com/200x100?text=Picture maybe?${item.id}',
          width: 200.0,
          height: 100.0,
        ),
        new Expanded(child: new Text(item.name))
      ],
    ),
  );
}

class Users extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text('User List'), backgroundColor: Colors.red,),
      body: new ListView.builder(
          itemCount: total,
          itemBuilder: (BuildContext context, int index) => _loadItem(index)),
    );
  }
}





