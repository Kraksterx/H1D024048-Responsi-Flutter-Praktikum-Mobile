import 'package:flutter/foundation.dart';
import 'package:responsi_flutter/models/location_model.dart';
import 'package:responsi_flutter/models/weather_model.dart';
import 'package:responsi_flutter/services/storage_service.dart';
import 'package:responsi_flutter/services/weather_api_service.dart';

class WeatherViewModel extends ChangeNotifier {
  final WeatherApiService _apiService;
  final StorageService _storageService;

  WeatherViewModel({
    WeatherApiService? apiService,
    StorageService? storageService,
  })  : _apiService = apiService ?? WeatherApiService(),
        _storageService = storageService ?? StorageService();

  static final LocationModel defaultLocation = LocationModel(
    name: 'Jakarta',
    latitude: -6.2088,
    longitude: 106.8456,
    country: 'Indonesia',
    admin1: 'DKI Jakarta',
  );

  LocationModel? _currentLocation;
  WeatherModel? _weather;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isFavorite = false;

  LocationModel get currentLocation => _currentLocation ?? defaultLocation;
  WeatherModel? get weather => _weather;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isFavorite => _isFavorite;
  bool get hasData => _weather != null;

  Future<void> initialize() async {
    final savedLocation = await _storageService.getLastLocation();
    _currentLocation = savedLocation ?? defaultLocation;
    await _checkFavoriteStatus();
    await fetchWeather();
  }

  Future<void> fetchWeather() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final loc = currentLocation;
      _weather = await _apiService.fetchWeather(
        latitude: loc.latitude,
        longitude: loc.longitude,
      );
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> selectLocation(LocationModel location) async {
    _currentLocation = location;
    await _storageService.saveLastLocation(location);
    await _storageService.addToSearchHistory(location);
    await _checkFavoriteStatus();
    await fetchWeather();
  }

  Future<void> toggleFavorite() async {
    final loc = currentLocation;
    if (_isFavorite) {
      await _storageService.removeFavorite(loc);
      _isFavorite = false;
    } else {
      await _storageService.saveFavorite(loc);
      _isFavorite = true;
    }
    notifyListeners();
  }

  Future<void> _checkFavoriteStatus() async {
    final loc = currentLocation;
    _isFavorite = await _storageService.isFavorite(loc);
    notifyListeners();
  }
}
