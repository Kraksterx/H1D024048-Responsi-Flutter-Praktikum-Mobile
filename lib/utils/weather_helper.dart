import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WeatherHelper {
  static String getWeatherDescription(int code) {
    switch (code) {
      case 0:
        return 'Cerah';
      case 1:
        return 'Cerah Berawan';
      case 2:
        return 'Sebagian Berawan';
      case 3:
        return 'Mendung / Berawan';
      case 45:
        return 'Berkabut';
      case 48:
        return 'Kabut Tebal';
      case 51:
        return 'Gerimis Ringan';
      case 53:
        return 'Gerimis Sedang';
      case 55:
        return 'Gerimis Lebat';
      case 56:
      case 57:
        return 'Gerimis Dingin';
      case 61:
        return 'Hujan Ringan';
      case 63:
        return 'Hujan Sedang';
      case 65:
        return 'Hujan Lebat';
      case 66:
      case 67:
        return 'Hujan Es Ringan';
      case 71:
        return 'Hujan Salju Ringan';
      case 73:
        return 'Hujan Salju Sedang';
      case 75:
        return 'Hujan Salju Lebat';
      case 77:
        return 'Salju Butiran';
      case 80:
        return 'Hujan Rintik';
      case 81:
        return 'Hujan Guyur Sedang';
      case 82:
        return 'Hujan Deras / Badai';
      case 85:
      case 86:
        return 'Hujan Salju Guyur';
      case 95:
        return 'Badai Petir';
      case 96:
      case 99:
        return 'Badai Petir Disertai Es';
      default:
        return 'Kondisi Normal';
    }
  }

  static IconData getWeatherIcon(int code) {
    switch (code) {
      case 0:
        return Icons.wb_sunny_rounded;
      case 1:
      case 2:
        return Icons.wb_cloudy_rounded;
      case 3:
        return Icons.cloud_rounded;
      case 45:
      case 48:
        return Icons.foggy;
      case 51:
      case 53:
      case 55:
      case 56:
      case 57:
        return Icons.grain_rounded;
      case 61:
      case 63:
      case 65:
      case 66:
      case 67:
        return Icons.water_drop_rounded;
      case 71:
      case 73:
      case 75:
      case 77:
        return Icons.ac_unit_rounded;
      case 80:
      case 81:
      case 82:
        return Icons.thunderstorm_rounded;
      case 95:
      case 96:
      case 99:
        return Icons.flash_on_rounded;
      default:
        return Icons.cloud_queue_rounded;
    }
  }

  static List<Color> getWeatherGradient(int code) {
    if (code == 0 || code == 1) {
      return [const Color(0xFF2980B9), const Color(0xFF6DD5FA)];
    } else if (code == 2 || code == 3) {
      return [const Color(0xFF4B6CB7), const Color(0xFF182848)];
    } else if (code >= 51 && code <= 67) {
      return [const Color(0xFF373B44), const Color(0xFF4286F4)];
    } else if (code >= 80 && code <= 99) {
      return [const Color(0xFF1F1C2C), const Color(0xFF928DAB)];
    } else {
      return [const Color(0xFF3A6073), const Color(0xFF3A7BD5)];
    }
  }

  static String formatForecastDate(String rawDate) {
    try {
      final parsed = DateTime.parse(rawDate);
      final now = DateTime.now();
      if (parsed.year == now.year &&
          parsed.month == now.month &&
          parsed.day == now.day) {
        return 'Hari Ini';
      }
      final tomorrow = now.add(const Duration(days: 1));
      if (parsed.year == tomorrow.year &&
          parsed.month == tomorrow.month &&
          parsed.day == tomorrow.day) {
        return 'Besok';
      }
      const days = [
        'Senin',
        'Selasa',
        'Rabu',
        'Kamis',
        'Jumat',
        'Sabtu',
        'Minggu'
      ];
      const months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'Mei',
        'Jun',
        'Jul',
        'Agt',
        'Sep',
        'Okt',
        'Nov',
        'Des'
      ];
      final dayName = days[parsed.weekday - 1];
      final monthName = months[parsed.month - 1];
      return '$dayName, ${parsed.day} $monthName';
    } catch (_) {
      return rawDate;
    }
  }

  static String formatCurrentTime(String rawTime) {
    try {
      final parsed = DateTime.parse(rawTime);
      return DateFormat('HH:mm').format(parsed);
    } catch (_) {
      return '';
    }
  }
}
