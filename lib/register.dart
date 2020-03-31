import 'package:flutter/material.dart';
import 'loging.dart';




class RegisterState extends State
{

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
                Text('Create your account' ),
                Text('Your Login will be:' ),
                Text('Your Password will be:' ),
                RaisedButton(child: Text('Create account!'), onPressed: ()
                {
                  Navigator.pop
                    (
                      context,
                      MaterialPageRoute(builder: (context) => Loging())
                  );
                },)
              ]
          )
      ),
    );









}
}


class  Register extends StatefulWidget
{
  @override
  RegisterState createState() => new RegisterState();
}