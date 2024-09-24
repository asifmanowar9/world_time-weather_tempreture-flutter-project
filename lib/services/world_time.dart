import 'package:http/http.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class WorldTime {
  String location;  // location to show
  String time = ""; // time of the location
  String flag;  // flag of country's
  String url;  // url for api
  late bool isDayTime;

  WorldTime({required this.location, required this.flag, required this.url});

  Future<void> getTime() async {
    try {
      // Make request
      Response response = await get(Uri.parse("http://worldtimeapi.org/api/timezone/$url")).timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        // Parse response data
        Map data = jsonDecode(response.body);

        // Get properties from the data
        String datetime = data['datetime'];
        String offset = data['utc_offset'].substring(1, 3);

        // Create a DateTime object
        DateTime now = DateTime.parse(datetime);
        now = now.add(Duration(hours: int.parse(offset)));

        // Check if it's day or night
        isDayTime = now.hour > 6 && now.hour < 18;

        // Format the time as a readable string
        time = DateFormat.jm().format(now);
      } else {
        throw "Failed to load data. Status Code: ${response.statusCode}";
      }
    } catch (e) {
      print("Caught error: $e");
      time = "Error loading time data. Please try again.";
    }
  }
}
