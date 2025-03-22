class Forecast {
  final DateTime date;
  final double maxTemp;
  final double minTemp;
  final String condition;
  final String iconUrl;

  Forecast({
    required this.date,
    required this.maxTemp,
    required this.minTemp,
    required this.condition,
    required this.iconUrl,
  });

  factory Forecast.fromJson(Map<String, dynamic> json) {
    final day = json['day'];
    return Forecast(
      date: DateTime.parse(json['date']),
      maxTemp: day['maxtemp_c'].toDouble(),
      minTemp: day['mintemp_c'].toDouble(),
      condition: day['condition']['text'],
      iconUrl: 'https:${day['condition']['icon']}',
    );
  }
}
