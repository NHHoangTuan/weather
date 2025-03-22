// "date": "2025-03-22",
//         "date_epoch": 1742601600,
//         "day": {
//           "maxtemp_c": 36.1,
//           "maxtemp_f": 97.0,
//           "mintemp_c": 25.0,
//           "mintemp_f": 77.1,
//           "avgtemp_c": 29.4,
//           "avgtemp_f": 85.0,
//           "maxwind_mph": 14.1,
//           "maxwind_kph": 22.7,
//           "totalprecip_mm": 0.0,
//           "totalprecip_in": 0.0,
//           "totalsnow_cm": 0.0,
//           "avgvis_km": 10.0,
//           "avgvis_miles": 6.0,
//           "avghumidity": 54,
//           "daily_will_it_rain": 0,
//           "daily_chance_of_rain": 0,
//           "daily_will_it_snow": 0,
//           "daily_chance_of_snow": 0,
//           "condition": {
//             "text": "Sunny",
//             "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png",
//             "code": 1000
//           },

class Forecast {
  final String date;
  final int dateEpoch;
  final double maxTempC;
  final double maxTempF;
  final double minTempC;
  final double minTempF;
  final double avgTempC;
  final double avgTempF;
  final double maxWindMph;
  final double maxWindKph;
  final double totalPrecipMm;
  final double totalPrecipIn;
  final double totalSnowCm;
  final double avgVisKm;
  final double avgVisMiles;
  final int avgHumidity;
  final int dailyWillItRain;
  final int dailyChanceOfRain;
  final int dailyWillItSnow;
  final int dailyChanceOfSnow;
  final WeatherCondition condition;
  final String iconUrl;

  Forecast({
    required this.date,
    required this.dateEpoch,
    required this.maxTempC,
    required this.maxTempF,
    required this.minTempC,
    required this.minTempF,
    required this.avgTempC,
    required this.avgTempF,
    required this.maxWindMph,
    required this.maxWindKph,
    required this.totalPrecipMm,
    required this.totalPrecipIn,
    required this.totalSnowCm,
    required this.avgVisKm,
    required this.avgVisMiles,
    required this.avgHumidity,
    required this.dailyWillItRain,
    required this.dailyChanceOfRain,
    required this.dailyWillItSnow,
    required this.dailyChanceOfSnow,
    required this.condition,
    required this.iconUrl,
  });

  factory Forecast.fromJson(Map<String, dynamic> json) {
    return Forecast(
      date: json['date'],
      dateEpoch: json['date_epoch'],
      maxTempC: json['day']['maxtemp_c'],
      maxTempF: json['day']['maxtemp_f'],
      minTempC: json['day']['mintemp_c'],
      minTempF: json['day']['mintemp_f'],
      avgTempC: json['day']['avgtemp_c'],
      avgTempF: json['day']['avgtemp_f'],
      maxWindMph: json['day']['maxwind_mph'],
      maxWindKph: json['day']['maxwind_kph'],
      totalPrecipMm: json['day']['totalprecip_mm'],
      totalPrecipIn: json['day']['totalprecip_in'],
      totalSnowCm: json['day']['totalsnow_cm'],
      avgVisKm: json['day']['avgvis_km'],
      avgVisMiles: json['day']['avgvis_miles'],
      avgHumidity: json['day']['avghumidity'],
      dailyWillItRain: json['day']['daily_will_it_rain'],
      dailyChanceOfRain: json['day']['daily_chance_of_rain'],
      dailyWillItSnow: json['day']['daily_will_it_snow'],
      dailyChanceOfSnow: json['day']['daily_chance_of_snow'],
      condition: WeatherCondition.fromJson(json['day']['condition']),
      iconUrl: 'https:${json['day']['condition']['icon']}',
    );
  }
}

class WeatherCondition {
  final String text;
  final String icon;
  final int code;

  WeatherCondition({
    required this.text,
    required this.icon,
    required this.code,
  });

  factory WeatherCondition.fromJson(Map<String, dynamic> json) {
    return WeatherCondition(
      text: json['text'],
      icon: 'https:${json['icon']}',
      code: json['code'],
    );
  }
}
