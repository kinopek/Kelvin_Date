// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
//import 'dart:html';
import 'dart:math' show cos, sqrt, asin;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:english_words/english_words.dart';
import 'geolocation.dart';


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

