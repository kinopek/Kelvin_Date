import 'geolocation.dart';
import 'package:flutter/material.dart';



class ForgotState extends State {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('KelvinDate'),
      ),
      body: Center(
          child: Column(
              children: <Widget>
              [
                Text('You should remember your own password'),

                RaisedButton(child: Text('I will still let you enter'), onPressed: () {
                  Navigator.push
                    (
                      context,
                      MaterialPageRoute(builder: (context) => GeolocationExample())
                  );
                },)
              ]
          )
      ),
    );
  }
}

  class  Forgot extends StatefulWidget
  {
  @override
  ForgotState createState() => new ForgotState();
  }




