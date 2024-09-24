import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  final String apiKey = '91b1bb8faa721e554a8a9a004d18abbd'; // Replace with your OpenWeatherMap API key
  final String city;

  WeatherService({required this.city});

  Future<Map> getWeather() async {
    try {
      String url =
          'http://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric';
      http.Response response = await http.get(Uri.parse(url));

      // Print the status code and response body to debug
      print('Status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        Map data = jsonDecode(response.body);
        return {
          'temperature': data['main']['temp'],
          'description': data['weather'][0]['description'],
        };
      } else {
        return {"error": "Error fetching weather"};
      }
    } catch (e) {
      return {"error": "Error: $e"};
    }
  }

}
