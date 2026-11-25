import 'package:flutter/material.dart';
import 'package:responsi_flutter/models/weather_model.dart';

class WeatherMetricsGrid extends StatelessWidget {
  final CurrentWeather current;

  const WeatherMetricsGrid({
    Key? key,
    required this.current,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
          child: Text(
            'Informasi Tambahan',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1C274C),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildMetricItem(
                icon: Icons.water_drop_outlined,
                iconColor: Colors.blueAccent,
                label: 'Kelembapan',
                value: '${current.relativeHumidity}%',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildMetricItem(
                icon: Icons.air_rounded,
                iconColor: Colors.teal,
                label: 'Kecepatan Angin',
                value: '${current.windSpeed} km/j',
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildMetricItem(
                icon: Icons.grain_rounded,
                iconColor: Colors.indigoAccent,
                label: 'Curah Hujan',
                value: '${current.precipitation} mm',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildMetricItem(
                icon: Icons.thermostat_rounded,
                iconColor: Colors.orangeAccent,
                label: 'Suhu Terasa',
                value: '${current.apparentTemperature.toStringAsFixed(1)}°C',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMetricItem({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1C274C),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
