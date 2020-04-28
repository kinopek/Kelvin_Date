import 'dart:async';
import 'dart:collection';
//import 'dart:html';
import 'dart:math' show cos, sqrt, asin;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
//import 'package:english_words/english_words.dart';
import 'package:geocoder/geocoder.dart';
import 'package:firebase_database/firebase_database.dart';
import 'fire.dart';
import 'package:flutter/widgets.dart';

class GeolocationExampleState extends State {
  Timer timer;

  Geolocator _geolocator;
  Position _position; //your phone
  double  _startingDistance = 100.0, _distance = 100.0;
  Coordinates c = new Coordinates(51.0, 17.0); //for testing
  final _coordinates = new Coordinates(
  //    51.1098966, 17.0326828); //rynek for now, another user later
      51.043, 17.079);//karels house approximation, for testing.





  Queue<double> _dist_archive = new Queue();
  static Fire f = new Fire();
  Coordinates c2 = f.getCoordinates(); //to get rynek from database

  void checkPermission() {
    _geolocator.checkGeolocationPermissionStatus().then((status) {
      print('status: $status');
    });
    _geolocator
        .checkGeolocationPermissionStatus(
            locationPermission: GeolocationPermission.locationAlways)
        .then((status) {
      print('always status: $status');
    });
    _geolocator.checkGeolocationPermissionStatus(
        locationPermission: GeolocationPermission.locationWhenInUse)
      ..then((status) {
        print('whenInUse status: $status');
      });
  }

  @override
  void initState() {
    super.initState();


    _geolocator = Geolocator();
    LocationOptions locationOptions =
        LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 1);

    checkPermission();
    updateLocation();

    StreamSubscription positionStream = _geolocator
        .getPositionStream(locationOptions)
        .listen((Position position) {
      _position = position;
    });

    timer = Timer.periodic(Duration(seconds: 1), (Timer t) => updateDistance());
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void updateLocation() async {
    try {
      Position newPosition = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
          .timeout(new Duration(seconds: 5));
      setState(() {
        _position = newPosition;
      });
    } catch (e) {
      print('Error: ${e.toString()}');
    }
  }

  double updateDistance() {
    setState(() {
      _distance = calculateDistance(_position.latitude, _position.longitude,
          _coordinates.latitude, _coordinates.longitude);
    });

    _dist_archive.add(_distance);
    if (_dist_archive.length > 10) {
      _dist_archive.removeFirst();
    }
    else if(_dist_archive.length == 1) {
      _startingDistance = _distance;
    }

    return _distance;
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    if ((lat1 == null) || (lon1 == null) || (lat2 == null) || (lon2 == null)) {
      return -1.0;
    }
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
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
        child: Column(children: <Widget>[
          Text(
              'Your Latitude: ${_position != null ? _position.latitude.toString() : 'processing'},',
              style: TextStyle(
                  // color: Colors.red,
                  fontSize: 20)),
          Text(
              'Your Longitude: ${_position != null ? _position.longitude.toString() : 'processing'}',
              style: TextStyle(
                  // color: Colors.red,
                  fontSize: 20)),
          Text(
              ' Rynek Latitude: ${_coordinates != null ? _coordinates.latitude.toString() : 'processing'},'),
          Text(
              ' Rynek Longitude: ${_coordinates != null ? _coordinates.longitude.toString() : 'processing'}'),
          Text(
              ' Distance in kilometers: ${_position != null ? updateDistance() : 'processing'},',
              style: TextStyle(
                  // color: Colors.red,
                  fontSize: 20)),
          Row(children: <Widget>[
            Expanded(
                child: Column(children: <Widget>[
              Icon(Icons.place),
              Text('Distance', textAlign: TextAlign.center)
            ])),
            Expanded(
              child:
              Thermometer(100.0, _distance, _startingDistance),

            ),

          ]),
          Row(children: <Widget>[
            RaisedButton(
              child: Text('Save to Database'),
              onPressed: () {
                f.createRecord(_position.latitude, _position.longitude);
              },
            ),
            RaisedButton(
              child: Text('Logout'),
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushReplacementNamed(context, "/login");
              },
            ),
            RaisedButton(
              child: Text('Users'),
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushNamed(context, "/users");
              },
            ),
          ]),
        ]),
      ),
    );
  }
}

class GeolocationExample extends StatefulWidget {
  @override
  GeolocationExampleState createState() => new GeolocationExampleState();
}

class Thermometer extends StatelessWidget
{
  final double thermoHeight, value, totalValue;
  double thermoWidth = 10.0;

  Thermometer(this.thermoHeight, this.value, this.totalValue);

  @override
  Widget build(BuildContext context)
  {
    double ratio= value / totalValue;

return Stack(
    alignment: AlignmentDirectional.bottomCenter,
    children: <Widget>
[
      Positioned(
bottom: thermoHeight*0.15,
        child:
    Container
    (
   // alignment: Alignment(3.0, 3.0),//bottomCenter,
    width: thermoWidth*0.7,
    height: thermoHeight,
    decoration: BoxDecoration
      (
        color: Colors.lightBlueAccent,
      //  borderRadius: BorderRadius.circular(5)
    ),
    child: Align
      (
        alignment: Alignment.bottomCenter,
        child: Material
          (
          borderRadius: BorderRadius.circular(5),
          child: AnimatedContainer(
            width: thermoWidth*0.5,
            height: (thermoHeight * (1-ratio) ).abs(),
            duration: Duration(milliseconds: 500),
            decoration: BoxDecoration(
                color: (ratio < 0.2) ? Colors.deepOrangeAccent : (ratio < 0.7) ? Colors.redAccent : Colors.red,
                borderRadius: BorderRadius.circular(5)),

          ),
        ),
    ),
  ),

    ),
      new Image.asset(
        'pic/th2.png',
        //alignment: Alignment(3.0,3.0),//.bottomLeft,
        height: thermoHeight*0.169,
        // width: thermoWidth*70,
      ),
  new Image.asset(
    'pic/th.png',
    //alignment: Alignment(3.0,3.0),//.bottomLeft,
    height: thermoHeight*1.25,
   // width: thermoWidth*70,
  ),







]
);

  }
}

