import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/weather.dart';
import '../models/forecast.dart';
import '../services/api_service.dart';

class WeatherRepository {
  final ApiService _apiService;

  WeatherRepository({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  Future<Weather> getCurrentWeather(String location) async {
    final weather = await _apiService.getCurrentWeather(location);
    // Save search history
    _saveToHistory(location, weather);
    return weather;
  }

  Future<List<Forecast>> getForecast(String location, {int days = 5}) async {
    return await _apiService.getForecast(location, days: days);
  }

  // Save search history to SharedPreferences
  Future<void> _saveToHistory(String location, Weather weather) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyJson = prefs.getString('weather_history') ?? '{}';
      final Map<String, dynamic> history = json.decode(historyJson);

      // Save weather information and search time
      history[location] = {
        'weather': {
          'temperature': weather.temperature,
          'humidity': weather.humidity,
          'windSpeed': weather.windSpeed,
          'condition': weather.condition,
          'iconUrl': weather.iconUrl,
        },
        'searchTime': DateTime.now().toIso8601String(),
        'lastUpdated': weather.lastUpdated.toIso8601String(),
      };

      await prefs.setString('weather_history', json.encode(history));
    } catch (e) {
      debugPrint('Error saving history: $e');
    }
  }

  // Lấy lịch sử tìm kiếm thời tiết từ SharedPreferences
  Future<Map<String, dynamic>> getSearchHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyJson = prefs.getString('weather_history') ?? '{}';
      return json.decode(historyJson);
    } catch (e) {
      debugPrint('Error reading history: $e');
      return {};
    }
  }
}
