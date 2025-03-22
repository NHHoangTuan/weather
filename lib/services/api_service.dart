import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/weather.dart';
import '../models/forecast.dart';

class ApiService {
  late final Dio _dio;
  final String _baseUrl = 'https://api.weatherapi.com/v1';

  ApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: _baseUrl,
      queryParameters: {
        'key': dotenv.env['WEATHER_API_KEY'],
      },
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ));

    // Log interceptor to debug API calls
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
    ));
  }

  Future<Weather> getCurrentWeather(String location) async {
    try {
      final response = await _dio
          .get('/current.json', queryParameters: {'q': location, 'aqi': 'no'});

      return Weather.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<Forecast>> getForecast(String location, {int days = 5}) async {
    try {
      final response = await _dio.get('/forecast.json', queryParameters: {
        'q': location,
        'days': days,
        'aqi': 'no',
        'alerts': 'no'
      });

      final List<dynamic> forecastDays =
          response.data['forecast']['forecastday'];
      return forecastDays.map((day) => Forecast.fromJson(day)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(DioException error) {
    String errorMessage = 'An error occurred while calling the API.';

    if (error.response != null) {
      errorMessage = error.response?.data?['error']?['message'] ??
          'Error: ${error.response?.statusCode}';
    } else if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      errorMessage = 'Server connection took too long, please try again';
    } else if (error.type == DioExceptionType.connectionError) {
      errorMessage =
          'Unable to connect to server, please check network connection';
    }

    return Exception(errorMessage);
  }
}
