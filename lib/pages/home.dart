import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:world_time/services/weather_service.dart'; // Import the weather service

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map data = {};
  Object? parameters;
  double temperature = 0.0;
  String weatherDescription = "Loading...";

  @override
  void initState() {
    super.initState();
    // Call fetchTemperature() after data is initialized
  }

  Future<void> fetchTemperature(String city) async {
    WeatherService weatherService = WeatherService(city: city);
    Map weatherData = await weatherService.getWeather();
    if (weatherData.containsKey('temperature')) {
      setState(() {
        temperature = weatherData['temperature'];
        weatherDescription = weatherData['description'];
      });
    } else {
      setState(() {
        weatherDescription = weatherData['error'] ?? "Error loading weather";
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    final parameters = ModalRoute.of(context)!.settings.arguments as Map?;
    data = data.isNotEmpty ? data : (parameters != null ? jsonDecode(jsonEncode(parameters)) : {});

    // Fetch temperature if location is set
    if (data.isNotEmpty && temperature == 0.0 && data['city'] != null) {
      fetchTemperature(data['city']);
    }

    String bgImage = data["isDayTime"] ? "day.png" : "night.png";
    Color? bgColor = data["isDayTime"] ? Colors.blue : Colors.indigo[700];

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/$bgImage"), // Use the dynamic image
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 120.0, 0, 0),
            child: Column(
              children: <Widget>[
                // Temperature and description section
                Text(
                  'Temperature: $temperature°C',
                  style: TextStyle(
                    fontSize: 28,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Weather: $weatherDescription',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      data["location"],
                      style: TextStyle(
                        fontSize: 24,
                        letterSpacing: 2,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.0),
                Text(
                  data["time"],
                  style: TextStyle(
                    fontSize: 66.0,
                    color: Colors.white,
                  ),
                ),
                TextButton.icon(
                  onPressed: () async {
                    dynamic result = await Navigator.pushNamed(context, "/location");
                    setState(() {
                      data = {
                        "time": result["time"],
                        'location': result['location'],
                        "flag": result['flag'],
                        'isDayTime': result['isDayTime'],
                        'city' : result['city']
                      };
                      fetchTemperature(result['city']);
                    });
                  },
                  icon: Icon(
                    Icons.edit_location,
                    color: Colors.grey[300],
                  ),
                  label: Text(
                    "Edit Location",
                    style: TextStyle(
                      color: Colors.grey[300],
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
