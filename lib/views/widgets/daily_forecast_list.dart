import 'package:flutter/material.dart';
import 'package:responsi_flutter/models/weather_model.dart';
import 'package:responsi_flutter/utils/weather_helper.dart';

class DailyForecastList extends StatelessWidget {
  final List<DailyForecast> forecasts;

  const DailyForecastList({
    Key? key,
    required this.forecasts,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (forecasts.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
          child: Text(
            'Prakiraan 7 Hari Ke Depan',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1C274C),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: forecasts.length,
            separatorBuilder: (context, index) => Divider(
              color: Colors.grey.shade100,
              height: 1,
              indent: 16,
              endIndent: 16,
            ),
            itemBuilder: (context, index) {
              final forecast = forecasts[index];
              final dateLabel = WeatherHelper.formatForecastDate(forecast.date);
              final iconData = WeatherHelper.getWeatherIcon(forecast.weatherCode);
              final description =
                  WeatherHelper.getWeatherDescription(forecast.weatherCode);

              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                child: Row(
                  children: [
                    SizedBox(
                      width: 90,
                      child: Text(
                        dateLabel,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: index == 0
                              ? FontWeight.bold
                              : FontWeight.w500,
                          color: index == 0
                              ? const Color(0xFF1E88E5)
                              : const Color(0xFF1C274C),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(iconData, color: const Color(0xFF1E88E5), size: 24),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            description,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF1C274C),
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (forecast.precipitationProbabilityMax > 0)
                            Row(
                              children: [
                                const Icon(
                                  Icons.umbrella_outlined,
                                  size: 12,
                                  color: Colors.blueAccent,
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  '${forecast.precipitationProbabilityMax}%',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.blueAccent,
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                    Text(
                      '${forecast.temperatureMin.round()}° / ${forecast.temperatureMax.round()}°',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1C274C),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
