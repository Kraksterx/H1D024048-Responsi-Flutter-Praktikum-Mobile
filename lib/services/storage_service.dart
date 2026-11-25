import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:responsi_flutter/models/location_model.dart';

class StorageService {
  static const String _keyFavorites = 'weather_favorite_locations';
  static const String _keyHistory = 'weather_search_history';
  static const String _keyLastLocation = 'weather_last_location';

  Future<List<LocationModel>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final String? rawData = prefs.getString(_keyFavorites);
    if (rawData == null || rawData.isEmpty) return [];

    try {
      final List<dynamic> decoded = json.decode(rawData);
      return decoded
          .map((item) => LocationModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveFavorite(LocationModel location) async {
    final favorites = await getFavorites();
    if (!favorites.any((item) => item == location)) {
      favorites.add(location);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        _keyFavorites,
        json.encode(favorites.map((e) => e.toJson()).toList()),
      );
    }
  }

  Future<void> removeFavorite(LocationModel location) async {
    final favorites = await getFavorites();
    favorites.removeWhere((item) => item == location);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _keyFavorites,
      json.encode(favorites.map((e) => e.toJson()).toList()),
    );
  }

  Future<bool> isFavorite(LocationModel location) async {
    final favorites = await getFavorites();
    return favorites.any((item) => item == location);
  }

  Future<List<LocationModel>> getSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final String? rawData = prefs.getString(_keyHistory);
    if (rawData == null || rawData.isEmpty) return [];

    try {
      final List<dynamic> decoded = json.decode(rawData);
      return decoded
          .map((item) => LocationModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> addToSearchHistory(LocationModel location) async {
    final history = await getSearchHistory();
    history.removeWhere((item) => item == location);
    history.insert(0, location);
    if (history.length > 10) {
      history.removeRange(10, history.length);
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _keyHistory,
      json.encode(history.map((e) => e.toJson()).toList()),
    );
  }

  Future<void> clearSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyHistory);
  }

  Future<void> saveLastLocation(LocationModel location) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyLastLocation, json.encode(location.toJson()));
  }

  Future<LocationModel?> getLastLocation() async {
    final prefs = await SharedPreferences.getInstance();
    final String? rawData = prefs.getString(_keyLastLocation);
    if (rawData == null || rawData.isEmpty) return null;

    try {
      final Map<String, dynamic> decoded = json.decode(rawData);
      return LocationModel.fromJson(decoded);
    } catch (_) {
      return null;
    }
  }
}
