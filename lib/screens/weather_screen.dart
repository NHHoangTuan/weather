import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather/providers/weather_provider.dart';

import '../widgets/forecast_list_widget.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({Key? key}) : super(key: key);

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late TextEditingController _cityController;

  @override
  void initState() {
    super.initState();
    _cityController = TextEditingController();
  }

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }

  Future<void> _handleSearch() async {
    final city = _cityController.text;
    if (city.isEmpty) return;

    try {
      // Call the fetchWeather method from the provider
      await context.read<WeatherProvider>().fetchWeather(city);
    } catch (e) {
      // Handle error
      debugPrint('Error searching weather: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 768;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather Dashboard',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.blue[600],
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Expanded(
                  child: isDesktop
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 1,
                              child: _buildSearchPanel(),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              flex: 2,
                              child: Consumer<WeatherProvider>(
                                builder: (context, weatherProvider, child) {
                                  final status = weatherProvider.status;
                                  if (status == WeatherStatus.loading) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  } else if (status == WeatherStatus.error) {
                                    return Center(
                                      child: Text(
                                        weatherProvider.errorMessage,
                                        style: const TextStyle(
                                          color: Colors.red,
                                          fontSize: 16,
                                        ),
                                      ),
                                    );
                                  } else if (status == WeatherStatus.success) {
                                    return _buildWeatherPanel(weatherProvider);
                                  } else {
                                    return const Center(
                                      child: Text(
                                          'Find a location to check the weather'),
                                    );
                                  }
                                },
                              ),
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            _buildSearchPanel(),
                            const SizedBox(height: 16),
                            Expanded(
                              child: Consumer<WeatherProvider>(
                                builder: (context, weatherProvider, child) {
                                  return _buildWeatherPanel(weatherProvider);
                                },
                              ),
                            ),
                          ],
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchPanel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Enter a City Name',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _cityController,
          decoration: InputDecoration(
            hintText: 'E.g., New York, London, Tokyo',
            fillColor: Colors.white,
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: () {
            _handleSearch();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue[700],
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: const Text(
            'Search',
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              Expanded(child: Divider(color: Colors.grey)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text('or', style: TextStyle(color: Colors.grey)),
              ),
              Expanded(child: Divider(color: Colors.grey)),
            ],
          ),
        ),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey,
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: const Text(
            'Use Current Location',
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildWeatherPanel(WeatherProvider weatherProvider) {
    final weather = weatherProvider.currentWeather;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Current Weather Panel
        Container(
          decoration: BoxDecoration(
            color: Colors.blue[700],
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${weather?.location.name} (${weather?.location.localtime})',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildWeatherInfoRow(
                        'Temperature:', '${weather?.current.tempC}°C'),
                    const SizedBox(height: 8),
                    _buildWeatherInfoRow(
                        'Wind:', '${weather?.current.windKph} km/h'),
                    const SizedBox(height: 8),
                    _buildWeatherInfoRow(
                        'Humidity:', '${weather?.current.humidity}%'),
                  ],
                ),
              ),
              Column(
                children: [
                  Image.network(
                    weather?.current.condition.icon ?? '',
                    width: 60,
                    height: 60,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.cloud,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${weather?.current.condition.text}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        // 4-Day Forecast Header
        const Text(
          '4-Day Forecast',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        // 4-Day Forecast Cards
        Expanded(
          child: ForecastList(
            forecasts: weatherProvider.forecast,
            onLoadMore: () {
              weatherProvider.loadMoreForecastDays();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildWeatherInfoRow(String label, String value) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildForecastCard(
    String date,
    String icon,
    double temp,
    double wind,
    int humidity,
  ) {
    return IntrinsicWidth(
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: Colors.grey.shade700,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '($date)',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            ImageIcon(
              NetworkImage(icon),
              size: 40,
              color: Colors.white,
            ),
            const SizedBox(height: 16),
            Text(
              '${temp.toStringAsFixed(1)}°C',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Wind: ${wind.toStringAsFixed(1)} km/h',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Humidity: $humidity%',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
