class WeatherModel {
  final String cityName;
  final double temperature;
  final double windSpeed;
  final int humidity;

  WeatherModel({
    required this.cityName,
    required this.temperature,
    required this.windSpeed,
    required this.humidity,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      cityName: json['location']['name'],
      temperature: json['current']['temp_c'],
      windSpeed: json['current']['wind_kph'] / 3.6, // Convert to m/s
      humidity: json['current']['humidity'],
    );
  }
}
