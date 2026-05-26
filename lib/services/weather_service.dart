import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';

class WeatherService {
  // Get your free API key from https://openweathermap.org/api
  // Sign up → go to API keys → copy your key → paste below
  static const String _apiKey = 'c0e11deea9fd714874cbf5107f897a28';
  static const String _baseUrl =
      'https://api.openweathermap.org/data/2.5/weather';

  Future<WeatherModel> fetchWeather(String city) async {
    if (_apiKey == 'YOUR_API_KEY_HERE') {
      throw Exception(
          'API key not set. Please get a free key from openweathermap.org and replace YOUR_API_KEY_HERE in weather_service.dart');
    }

    final uri = Uri.parse(
      '$_baseUrl?q=$city&appid=$_apiKey&units=metric',
    );

    try {
      final response = await http.get(uri).timeout(
            const Duration(seconds: 10),
            onTimeout: () =>
                throw Exception('Request timed out. Check your connection.'),
          );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return WeatherModel.fromJson(json);
      } else if (response.statusCode == 401) {
        throw Exception(
            'Invalid API key. Please check your key at openweathermap.org');
      } else if (response.statusCode == 404) {
        throw Exception('City "$city" not found. Try another city name.');
      } else {
        throw Exception(
            'Server error (${response.statusCode}). Try again later.');
      }
    } on Exception {
      rethrow;
    } catch (e) {
      throw Exception('Network error. Check your internet connection.');
    }
  }
}
