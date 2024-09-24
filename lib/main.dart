import 'package:flutter/material.dart';
import 'package:world_time/pages/choose_location.dart';
import 'package:world_time/pages/home.dart';
import 'package:world_time/pages/loading_page.dart';


void main() {
  runApp( MaterialApp(
    //home: Home(),
    //initialRoute: "/",
    routes: {
      "/": (context) => LoadingPage(),
      "/home": (context) => Home(),
      "/location": (context) => ChooseLocation(),
    },
  ));
}

