import 'package:http/http.dart' as http;
import 'dart:convert';

class WeatherUtil {
  static Future<List<String>> getWeatherData(String city) async {
    const apiKey = 'c0ccd7e4d8a0a210c77267062e33c2bc';
    final apiEndpoint = 'https://api.openweathermap.org/data/2.5/forecast?q=$city&appid=$apiKey';
    final weatherData = <String>[];

    try {
      final response = await http.get(Uri.parse(apiEndpoint));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final dailyForecasts = data['list'];

        String currentDate = '';
        for (var forecast in dailyForecasts) {
          final timestamp = forecast['dt_txt'];
          final date = timestamp.split(' ')[0];
          final minTemp = forecast['main']['temp_min'];
          final maxTemp = forecast['main']['temp_max'];
          final weatherDescription = forecast['weather'][0]['description'];
          final icon = forecast['weather'][0]['icon'];

          if (date != currentDate) {
            currentDate = date;
            //final formattedData = 'Date: $date\nMin Temp: ${minTemp.toStringAsFixed(2)}K\nMax Temp: ${maxTemp.toStringAsFixed(2)}K\nWeather: $weatherDescription\n';
            final formattedData = icon;
             //final formattedData = 'Date: $date\nTime: $date\nIcon: $icon';
            weatherData.add(formattedData);
          }
        }
      } else {
        // Handle HTTP request errors.
        weatherData.add('Failed to fetch weather data');
      }
    } catch (e) {
      // Handle other errors.
      weatherData.add('An error occurred: $e');
    }

    return weatherData;
  }
}
