import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/weather_model.dart';
import '../services/weather_service.dart';
import '../widgets/weather_info_card.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final WeatherService _service = WeatherService();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  WeatherModel? _weather;
  bool _isLoading = false;
  String? _errorMessage;
  String _currentCity = 'Delhi';

  final List<String> _quickCities = [
    'Delhi', 'Mumbai', 'London', 'New York', 'Tokyo', 'Paris',
  ];

  @override
  void initState() {
    super.initState();
    _fetchWeather(_currentCity);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _fetchWeather(String city) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final weather = await _service.fetchWeather(city);
      setState(() {
        _weather = weather;
        _currentCity = city;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  void _onSearch() {
    final city = _searchController.text.trim();
    if (city.isNotEmpty) {
      _focusNode.unfocus();
      _fetchWeather(city);
      _searchController.clear();
    }
  }

  Color _hexToColor(String hex) {
    return Color(int.parse(hex.replaceFirst('#', '0xFF')));
  }

  @override
  Widget build(BuildContext context) {
    final gradients = _weather?.gradientColors ??
        [['#3A7BD5', '#00D2FF'], ['#2C5F8A', '#3A7BD5']];

    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              _hexToColor(gradients[0][0]),
              _hexToColor(gradients[0][1]),
              _hexToColor(gradients[1][0]),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildSearchBar(),
              _buildQuickCities(),
              Expanded(child: _buildBody()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.3)),
              ),
              child: TextField(
                controller: _searchController,
                focusNode: _focusNode,
                style: const TextStyle(color: Colors.white),
                onSubmitted: (_) => _onSearch(),
                decoration: InputDecoration(
                  hintText: 'Search city...',
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
                  prefixIcon: const Icon(Icons.search, color: Colors.white70),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: _onSearch,
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.25),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.arrow_forward, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickCities() {
    return SizedBox(
      height: 36,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: _quickCities.length,
        itemBuilder: (context, i) {
          final city = _quickCities[i];
          final isSelected = city == _currentCity;
          return GestureDetector(
            onTap: () => _fetchWeather(city),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white.withOpacity(0.35)
                    : Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? Colors.white.withOpacity(0.7)
                      : Colors.white.withOpacity(0.2),
                ),
              ),
              child: Text(
                city,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight:
                      isSelected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 13,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) return _buildLoading();
    if (_errorMessage != null) return _buildError();
    if (_weather != null) return _buildWeatherContent();
    return const SizedBox();
  }

  Widget _buildLoading() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Colors.white),
          SizedBox(height: 16),
          Text('Fetching weather...', style: TextStyle(color: Colors.white70, fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('⚠️', style: TextStyle(fontSize: 60)),
            const SizedBox(height: 16),
            Text(
              _errorMessage!,
              style: const TextStyle(color: Colors.white, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => _fetchWeather(_currentCity),
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.25),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherContent() {
    final w = _weather!;
    final now = DateTime.now();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 10),

          // Location + date
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.location_on, color: Colors.white70, size: 18),
              const SizedBox(width: 4),
              Text(
                '${w.cityName}, ${w.country}',
                style: const TextStyle(
                    color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            DateFormat('EEEE, d MMM yyyy').format(now),
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),

          const SizedBox(height: 30),

          // Main temperature
          Text(w.weatherEmoji, style: const TextStyle(fontSize: 80)),
          const SizedBox(height: 8),
          Text(
            '${w.temperature.round()}°C',
            style: const TextStyle(
                color: Colors.white, fontSize: 72, fontWeight: FontWeight.bold),
          ),
          Text(
            w.description.toUpperCase(),
            style: const TextStyle(
                color: Colors.white70, fontSize: 14, letterSpacing: 2),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('↑ ${w.tempMax.round()}°',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              const SizedBox(width: 16),
              Text('↓ ${w.tempMin.round()}°',
                  style: const TextStyle(color: Colors.white70)),
              const SizedBox(width: 16),
              Text('Feels like ${w.feelsLike.round()}°',
                  style: const TextStyle(color: Colors.white70)),
            ],
          ),

          const SizedBox(height: 30),

          // Info grid
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.6,
            children: [
              WeatherInfoCard(
                  label: 'Humidity',
                  value: '${w.humidity}%',
                  icon: Icons.water_drop_outlined),
              WeatherInfoCard(
                  label: 'Wind Speed',
                  value: '${w.windSpeed.toStringAsFixed(1)} m/s',
                  icon: Icons.air),
              WeatherInfoCard(
                  label: 'Visibility',
                  value: '${(w.visibility / 1000).toStringAsFixed(1)} km',
                  icon: Icons.visibility_outlined),
              WeatherInfoCard(
                  label: 'Pressure',
                  value: '${w.pressure} hPa',
                  icon: Icons.speed_outlined),
            ],
          ),

          const SizedBox(height: 12),

          // Sunrise / Sunset
          Row(
            children: [
              Expanded(
                child: WeatherInfoCard(
                    label: 'Sunrise',
                    value: DateFormat('h:mm a').format(w.sunrise),
                    icon: Icons.wb_sunny_outlined),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: WeatherInfoCard(
                    label: 'Sunset',
                    value: DateFormat('h:mm a').format(w.sunset),
                    icon: Icons.nightlight_round),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Last updated
          Text(
            'Last updated: ${DateFormat('h:mm a').format(now)}',
            style: const TextStyle(color: Colors.white38, fontSize: 12),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () => _fetchWeather(_currentCity),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.refresh, color: Colors.white54, size: 16),
                SizedBox(width: 4),
                Text('Tap to refresh',
                    style: TextStyle(color: Colors.white54, fontSize: 12)),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
