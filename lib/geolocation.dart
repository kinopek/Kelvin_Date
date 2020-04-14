import 'dart:async';
import 'dart:collection';
//import 'dart:html';
import 'dart:math' show cos, sqrt, asin;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
//import 'package:english_words/english_words.dart';
import 'package:geocoder/geocoder.dart';
import 'package:firebase_database/firebase_database.dart';
import 'fire.dart';

class GeolocationExampleState extends State
{
  Geolocator _geolocator;
  Position _position; //your phone
  Coordinates c = new Coordinates  (51.0, 17.0);//for testing
  final _coordinates = new Coordinates  (51.1098966,17.0326828);//rynek for now, another user later
  double _distance = 100.0;
  Queue<double> _dist_archive= new Queue();
  static Fire f = new Fire();
  Coordinates c2 = f.getCoordinates( );//to get rynek from database

  void checkPermission() {
    _geolocator.checkGeolocationPermissionStatus().then((status) { print('status: $status'); });
    _geolocator.checkGeolocationPermissionStatus(locationPermission: GeolocationPermission.locationAlways).then((status) { print('always status: $status'); });
    _geolocator.checkGeolocationPermissionStatus(locationPermission: GeolocationPermission.locationWhenInUse)..then((status) { print('whenInUse status: $status'); });
  }

  @override
  void initState() {
    super.initState();

    _geolocator = Geolocator();
    LocationOptions locationOptions = LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 1);

    checkPermission();
    //    updateLocation();

    StreamSubscription positionStream = _geolocator.getPositionStream(locationOptions).listen(
            (Position position)
        {
          setState(() {
            _position = position;
          });
        });
  }

  void updateLocation() async {
    try {

      Position newPosition = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
          .timeout(new Duration(seconds: 5));
      setState(() {
        _position = newPosition;
      });
    } catch (e) {
      print('Error: ${e.toString()}');
    }
  }

  double updateDistance()
  {
    setState(()
    {
      _distance=calculateDistance(_position.latitude, _position.longitude, _coordinates.latitude, _coordinates.longitude);
    });

    _dist_archive.add(_distance);
    if(_dist_archive.length>10)
    {
      _dist_archive.removeFirst();
    }
    return _distance;
  }

  double calculateDistance(lat1, lon1, lat2, lon2)
  {
    if((lat1 == null)||(lon1 == null)||(lat2 == null)||(lon2 == null))
    {
      return -1.0;
    }
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) *
            (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('KelvinDate'),
        backgroundColor: Colors.red,
      ),
      body: Center(
        child: Column(
          children: <Widget>
        [
            Text('Your Latitude: ${_position != null ? _position.latitude.toString() : 'processing'},',
          style: TextStyle(
             // color: Colors.red,
              fontSize: 20
          )
      ),
            Text('Your Longitude: ${_position != null ? _position.longitude.toString() : 'processing'}',
                style: TextStyle(
                  // color: Colors.red,
                    fontSize: 20
                )
            ),
            Text(' Rynek Latitude: ${_coordinates != null ? _coordinates.latitude.toString() : 'processing'},'),
            Text(' Rynek Longitude: ${_coordinates != null ? _coordinates.longitude.toString() : 'processing'}'),
            Text(' Distance in kilometers: ${_position != null ? updateDistance() : 'processing'},' ,
                style: TextStyle(
                  // color: Colors.red,
                    fontSize: 20
                )
            ),
            RaisedButton(child: Text('Save to Database'), onPressed: () {f.createRecord(_position.latitude, _position.longitude);},)
        ]
            )
      ),
    );
  }
}

class GeolocationExample extends StatefulWidget {
  @override
  GeolocationExampleState createState() => new GeolocationExampleState();
}