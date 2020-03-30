// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
//import 'dart:html';
import 'dart:math' show cos, sqrt, asin;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:english_words/english_words.dart';
import 'package:geocoder/geocoder.dart';

void main() => runApp(MyApp());

class MyApp  extends StatelessWidget
{

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'KelvinDate',//Nazwa Procesu
      home: GeolocationExample( ),
    );
  }

}

class GeolocationExampleState extends State
{
  Geolocator _geolocator;
  Position _position; //your phone
  Coordinates c = new Coordinates  (51.0, 17.0);//for testing
  final _coordinates = new Coordinates  (51.1098966,17.0326828);//rynek for now

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
          _position = position;
        });
  }

  void updateLocation() async {
    try {


      //final coordinates = new Coordinates(1.10, 45.50);
      //var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
     //_rynek = addresses.first.coordinates;

      Position newPosition = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
          .timeout(new Duration(seconds: 5));


      //_distanceInMeters = await calculateDist(_position as Coordinates, _coordinates);
      //print( _distanceInMeters);

      setState(() {
        _position = newPosition;
      });



    } catch (e) {
      print('Error: ${e.toString()}');
    }
  }
/*
  Future<double> calculateDist(Coordinates a, Coordinates b) async
  {
    double _d;
    try {
      double newDistance = await Geolocator().distanceBetween(a.latitude, a.longitude, b.latitude, b.longitude).timeout(new Duration(seconds: 5));

      setState(() {
        _d = newDistance;
      });
    } catch (e) {
      print('Error: ${e.toString()}');
    }
    return _d;
  }
*/

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
      ),
      body: Center(
          child: Text(
              'Your Latitude: ${_position != null ? _position.latitude.toString() : '0'},'
                  ' Your Longitude: ${_position != null ? _position.longitude.toString() : '0'}'
                  ' Rynek Latitude: ${_coordinates != null ? _coordinates.latitude.toString() : '0'},'
                  ' Rynek Longitude: ${_coordinates != null ? _coordinates.longitude.toString() : '0'}'
                  ' Distance in kilometers: ${calculateDistance(_position.latitude, _position.longitude, _coordinates.latitude, _coordinates.longitude) != null && calculateDistance(_position.latitude, _position.longitude, _coordinates.latitude, _coordinates.longitude) >=0 ? calculateDistance(_position.latitude, _position.longitude, _coordinates.latitude, _coordinates.longitude) : '0'}'
          )
      ),
    );
  }
}

class GeolocationExample extends StatefulWidget {
  @override
  GeolocationExampleState createState() => new GeolocationExampleState();
}
