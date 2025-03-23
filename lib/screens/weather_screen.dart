import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather/providers/weather_provider.dart';

import '../services/location_service.dart';
import '../widgets/forecast_list_widget.dart';
import '../widgets/search_history.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({Key? key}) : super(key: key);

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late TextEditingController _cityController;
  final LocationService _locationService = LocationService();

  @override
  void initState() {
    super.initState();
    _cityController = TextEditingController();

    // Load the search history after the first frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WeatherProvider>().loadSearchHistory();
    });
  }

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }

  Future<void> _handleSearch() async {
    final city = _cityController.text;
    if (city.isEmpty) return;

    final weatherProvider = context.read<WeatherProvider>();
    try {
      // Call the fetchWeather method from the provider
      await weatherProvider.fetchWeather(city);

      await weatherProvider.loadSearchHistory();
    } catch (e) {
      // Handle error
      debugPrint('Error searching weather: $e');
    }
  }

  Future<void> _handleCurrentLocation() async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Getting your location...')),
      );

      final weatherProvider = context.read<WeatherProvider>();

      final position = await _locationService.getCurrentPosition(context);

      if (position != null) {
        await weatherProvider.fetchWeatherByCoordinates(
          position.latitude,
          position.longitude,
        );
      }

      weatherProvider.clearCurrentLocation();
    } catch (e) {
      debugPrint('Error getting current location: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
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
                              flex: 3,
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
                                    return _buildWeatherPanel(
                                        weatherProvider, isDesktop);
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
                                final status = weatherProvider.status;
                                if (status == WeatherStatus.loading) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else {
                                  return _buildWeatherPanel(
                                      weatherProvider, isDesktop);
                                }
                              }),
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
        const Row(
          children: [
            Expanded(
              child: Text(
                'Enter a City Name',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: TextField(
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
            ),
            Consumer<WeatherProvider>(
              builder: (context, provider, _) {
                final hasHistory = provider.searchHistory.isNotEmpty;

                return IconButton(
                  onPressed: () {
                    if (hasHistory) {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => const SearchHistory(),
                      );
                    } else {
                      null;
                    }
                  },
                  icon: Icon(
                    Icons.history,
                    color: hasHistory ? Colors.blue[700] : Colors.grey,
                  ),
                  tooltip: 'Search history',
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: () {
            _handleSearch();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue[700],
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
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
          onPressed: () {
            _handleCurrentLocation();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey,
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            'Use Current Location',
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildWeatherPanel(WeatherProvider weatherProvider, bool isDesktop) {
    final weather = weatherProvider.currentWeather;
    if (weather == null) {
      return const Center(
        child: Text('No weather data available'),
      );
    }
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      child: Column(
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
                        '${weather.location.name} (${weather.location.localtime})',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildWeatherInfoRow(
                          'Temperature:', '${weather.current.tempC}°C'),
                      const SizedBox(height: 8),
                      _buildWeatherInfoRow(
                          'Wind:', '${weather.current.windKph} km/h'),
                      const SizedBox(height: 8),
                      _buildWeatherInfoRow(
                          'Humidity:', '${weather.current.humidity}%'),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Image.network(
                      weather.current.condition.icon,
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
                      weather.current.condition.text,
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
          isDesktop
              ? SizedBox(
                  height: 400,
                  child: ForecastList(
                    forecasts: weatherProvider.forecast,
                    onLoadMore: () {
                      if (weatherProvider.status == WeatherStatus.loading) {
                        return;
                      }
                      weatherProvider.loadMoreForecastDays();
                    },
                  ),
                )
              : ForecastList(
                  forecasts: weatherProvider.forecast,
                  onLoadMore: () {
                    if (weatherProvider.status == WeatherStatus.loading) {
                      return;
                    }
                    weatherProvider.loadMoreForecastDays();
                  },
                ),
        ],
      ),
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
}
