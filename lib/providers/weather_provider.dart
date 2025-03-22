import 'package:flutter/material.dart';
import 'package:weather/repository/weather_repository.dart';
import '../models/weather.dart';
import '../models/forecast.dart';

enum WeatherStatus { initial, loading, success, error }

class WeatherProvider extends ChangeNotifier {
  final WeatherRepository _repository = WeatherRepository();

  Weather? _currentWeather;
  List<Forecast> _forecast = [];
  String _errorMessage = '';
  WeatherStatus _status = WeatherStatus.initial;
  String _currentLocation = '';
  Map<String, dynamic> _searchHistory = {};

  Weather? get currentWeather => _currentWeather;
  List<Forecast> get forecast => _forecast;
  String get errorMessage => _errorMessage;
  WeatherStatus get status => _status;
  String get currentLocation => _currentLocation;
  Map<String, dynamic> get searchHistory => _searchHistory;

  Future<void> fetchWeather(String location) async {
    if (location.isEmpty) return;

    _status = WeatherStatus.loading;
    _currentLocation = location;
    notifyListeners();

    try {
      _currentWeather = await _repository.getCurrentWeather(location);
      _forecast = await _repository.getForecast(location);
      _forecast.removeAt(0); // Remove the current day from the forecast list
      _status = WeatherStatus.success;
    } catch (e) {
      _errorMessage = e.toString();
      _status = WeatherStatus.error;
    }

    notifyListeners();
  }

  Future<void> loadMoreForecastDays() async {
    if (_currentLocation.isEmpty) return;

    try {
      final additionalDays = await _repository.getForecast(_currentLocation,
          days: _forecast.length + 3);

      final currentDates = _forecast.map((f) => f.dateEpoch).toSet();
      final newForecastDays = additionalDays
          .where((day) => !currentDates.contains(day.dateEpoch))
          .toList();

      _forecast.addAll(newForecastDays);
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> loadSearchHistory() async {
    try {
      _searchHistory = await _repository.getSearchHistory();
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }
}
