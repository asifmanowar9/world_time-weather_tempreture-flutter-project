import 'package:flutter/material.dart';
import 'package:world_time/services/weather_service.dart';
import 'package:world_time/services/world_time.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


class LoadingPage extends StatefulWidget {


  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {



  void setWorldTime() async {
    try {
      WorldTime instance = WorldTime(location: "Dhaka", flag: "bangladesh.png", url: "Asia/Dhaka");
      await instance.getTime();
      Navigator.pushReplacementNamed(context, "/home", arguments: {
        "location": instance.location,
        "flag": instance.flag,
        "time": instance.time,
        "isDayTime": instance.isDayTime,
        "city": instance.location,
      });
    } catch (e) {
      print("Error: $e");
      // Display an error message on the UI
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading time data. Please try again.')),
      );
    }
  }



  @override
  void initState() {
    super.initState();
    setWorldTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[900],
      body: Center(
        child: SpinKitSpinningLines(
          color: Colors.white,
          size: 80.0,
        ),
      ),
    );
  }
}
