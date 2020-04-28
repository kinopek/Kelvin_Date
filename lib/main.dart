import 'package:flutter/material.dart';
import 'package:kelvindate/register.dart';
import 'SplashPage.dart';
import 'Users.dart';
import 'geolocation.dart';
import 'loging.dart';

void main() => runApp(MyApp());

class MyApp  extends StatelessWidget
{

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'KelvinDate',//Nazwa Procesu
      home: SplashPage(),
        routes: <String, WidgetBuilder>{
          '/home': (BuildContext context) => GeolocationExample(),
          '/login': (BuildContext context) => Loging(),
          '/register': (BuildContext context) => Register(),
          '/users': (BuildContext context) => Users(),

        });
  }

}

