class WeatherModel {
  final String cityName;
  final String country;
  final double temperature;
  final double feelsLike;
  final double tempMin;
  final double tempMax;
  final String condition;
  final String description;
  final int humidity;
  final double windSpeed;
  final int visibility;
  final int pressure;
  final DateTime sunrise;
  final DateTime sunset;
  final String icon;

  WeatherModel({
    required this.cityName,
    required this.country,
    required this.temperature,
    required this.feelsLike,
    required this.tempMin,
    required this.tempMax,
    required this.condition,
    required this.description,
    required this.humidity,
    required this.windSpeed,
    required this.visibility,
    required this.pressure,
    required this.sunrise,
    required this.sunset,
    required this.icon,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      cityName: json['name'],
      country: json['sys']['country'],
      temperature: (json['main']['temp'] as num).toDouble(),
      feelsLike: (json['main']['feels_like'] as num).toDouble(),
      tempMin: (json['main']['temp_min'] as num).toDouble(),
      tempMax: (json['main']['temp_max'] as num).toDouble(),
      condition: json['weather'][0]['main'],
      description: json['weather'][0]['description'],
      humidity: json['main']['humidity'],
      windSpeed: (json['wind']['speed'] as num).toDouble(),
      visibility: json['visibility'],
      pressure: json['main']['pressure'],
      sunrise: DateTime.fromMillisecondsSinceEpoch(json['sys']['sunrise'] * 1000),
      sunset: DateTime.fromMillisecondsSinceEpoch(json['sys']['sunset'] * 1000),
      icon: json['weather'][0]['icon'],
    );
  }

  String get weatherEmoji {
    switch (condition.toLowerCase()) {
      case 'clear':
        return '☀️';
      case 'clouds':
        return '☁️';
      case 'rain':
        return '🌧️';
      case 'drizzle':
        return '🌦️';
      case 'thunderstorm':
        return '⛈️';
      case 'snow':
        return '❄️';
      case 'mist':
      case 'fog':
      case 'haze':
        return '🌫️';
      default:
        return '🌤️';
    }
  }

  List<List<String>> get gradientColors {
    switch (condition.toLowerCase()) {
      case 'clear':
        return [['#FF8C00', '#FFD700'], ['#FF6B35', '#FF8C00']];
      case 'clouds':
        return [['#4A90D9', '#6BB3F0'], ['#2C5F8A', '#4A90D9']];
      case 'rain':
      case 'drizzle':
        return [['#2C3E6B', '#4A6FA5'], ['#1A2744', '#2C3E6B']];
      case 'thunderstorm':
        return [['#1A1A2E', '#16213E'], ['#0F0F1A', '#1A1A2E']];
      case 'snow':
        return [['#74B9FF', '#A8D8EA'], ['#4A90D9', '#74B9FF']];
      default:
        return [['#3A7BD5', '#00D2FF'], ['#2C5F8A', '#3A7BD5']];
    }
  }
}
