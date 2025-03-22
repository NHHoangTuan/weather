class Weather {
  final double temperature;
  final int humidity;
  final double windSpeed;
  final String condition;
  final String iconUrl;
  final DateTime lastUpdated;

  Weather({
    required this.temperature,
    required this.humidity,
    required this.windSpeed,
    required this.condition,
    required this.iconUrl,
    required this.lastUpdated,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    final current = json['current'];
    return Weather(
      temperature: current['temp_c'].toDouble(),
      humidity: current['humidity'],
      windSpeed: current['wind_kph'].toDouble(),
      condition: current['condition']['text'],
      iconUrl: 'https:${current['condition']['icon']}',
      lastUpdated: DateTime.parse(current['last_updated']),
    );
  }
}
