class CurrentWeather {
  final String time;
  final double temperature;
  final int relativeHumidity;
  final double apparentTemperature;
  final double precipitation;
  final int weatherCode;
  final double windSpeed;

  CurrentWeather({
    required this.time,
    required this.temperature,
    required this.relativeHumidity,
    required this.apparentTemperature,
    required this.precipitation,
    required this.weatherCode,
    required this.windSpeed,
  });

  factory CurrentWeather.fromJson(Map<String, dynamic> json) {
    return CurrentWeather(
      time: json['time'] as String? ?? '',
      temperature: (json['temperature_2m'] as num?)?.toDouble() ?? 0.0,
      relativeHumidity: (json['relative_humidity_2m'] as num?)?.toInt() ?? 0,
      apparentTemperature:
          (json['apparent_temperature'] as num?)?.toDouble() ?? 0.0,
      precipitation: (json['precipitation'] as num?)?.toDouble() ?? 0.0,
      weatherCode: (json['weather_code'] as num?)?.toInt() ?? 0,
      windSpeed: (json['wind_speed_10m'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class DailyForecast {
  final String date;
  final int weatherCode;
  final double temperatureMax;
  final double temperatureMin;
  final int precipitationProbabilityMax;

  DailyForecast({
    required this.date,
    required this.weatherCode,
    required this.temperatureMax,
    required this.temperatureMin,
    required this.precipitationProbabilityMax,
  });
}

class WeatherModel {
  final double latitude;
  final double longitude;
  final String timezone;
  final CurrentWeather current;
  final List<DailyForecast> daily;

  WeatherModel({
    required this.latitude,
    required this.longitude,
    required this.timezone,
    required this.current,
    required this.daily,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    final currentMap = json['current'] as Map<String, dynamic>? ?? {};
    final dailyMap = json['daily'] as Map<String, dynamic>? ?? {};

    final times = (dailyMap['time'] as List<dynamic>?) ?? [];
    final weatherCodes = (dailyMap['weather_code'] as List<dynamic>?) ?? [];
    final tempMaxs = (dailyMap['temperature_2m_max'] as List<dynamic>?) ?? [];
    final tempMins = (dailyMap['temperature_2m_min'] as List<dynamic>?) ?? [];
    final precipProbs =
        (dailyMap['precipitation_probability_max'] as List<dynamic>?) ?? [];

    final dailyList = <DailyForecast>[];
    final count = times.length;
    for (int i = 0; i < count; i++) {
      dailyList.add(
        DailyForecast(
          date: times[i] as String? ?? '',
          weatherCode: i < weatherCodes.length
              ? (weatherCodes[i] as num).toInt()
              : 0,
          temperatureMax: i < tempMaxs.length
              ? (tempMaxs[i] as num).toDouble()
              : 0.0,
          temperatureMin: i < tempMins.length
              ? (tempMins[i] as num).toDouble()
              : 0.0,
          precipitationProbabilityMax: i < precipProbs.length
              ? ((precipProbs[i] as num?)?.toInt() ?? 0)
              : 0,
        ),
      );
    }

    return WeatherModel(
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      timezone: json['timezone'] as String? ?? 'auto',
      current: CurrentWeather.fromJson(currentMap),
      daily: dailyList,
    );
  }
}
