import 'package:flutter/material.dart';
import 'const.dart';
import 'package:photo_view/photo_view.dart';

// EKran do wyświetlania wysłanego w czacie zdjęcia - jeszcze nie testowałem, bo jeszcze nie działa wysyłanie zdjęcia(ale chyba przez mały bug, który szybko naprawie)
class FullPhoto extends StatelessWidget {
  final String url;

  // Konstruktor z ur do zdjęcia.
  FullPhoto({Key key, @required this.url}) : super(key: key);

  // Budowanie UI.
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(
          'FULL PHOTO',
          style: TextStyle(color: secondaryColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: new FullPhotoScreen(url: url),
    );
  }
}

// Znowu klasa po raz drugi XD.
class FullPhotoScreen extends StatefulWidget {
  final String url;

  FullPhotoScreen({Key key, @required this.url}) : super(key: key);

  @override
  State createState() => new FullPhotoScreenState(url: url);
}

// I po raz trzeci XD
class FullPhotoScreenState extends State<FullPhotoScreen> {
  final String url;

  FullPhotoScreenState({Key key, @required this.url});

  @override
  void initState() {
    super.initState();
  }

  // Budowanie UI.
  @override
  Widget build(BuildContext context) {
    // Sam podgląd zdjęcia z URL, nic więcej.
    return Container(child: PhotoView(imageProvider: NetworkImage(url)));
  }
}