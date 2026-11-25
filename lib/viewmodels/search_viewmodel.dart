import 'package:flutter/foundation.dart';
import 'package:responsi_flutter/models/location_model.dart';
import 'package:responsi_flutter/services/storage_service.dart';
import 'package:responsi_flutter/services/weather_api_service.dart';

class SearchViewModel extends ChangeNotifier {
  final WeatherApiService _apiService;
  final StorageService _storageService;

  SearchViewModel({
    WeatherApiService? apiService,
    StorageService? storageService,
  })  : _apiService = apiService ?? WeatherApiService(),
        _storageService = storageService ?? StorageService();

  List<LocationModel> _searchResults = [];
  List<LocationModel> _favorites = [];
  List<LocationModel> _history = [];
  bool _isSearching = false;
  String? _errorMessage;
  String _currentQuery = '';

  List<LocationModel> get searchResults => _searchResults;
  List<LocationModel> get favorites => _favorites;
  List<LocationModel> get history => _history;
  bool get isSearching => _isSearching;
  String? get errorMessage => _errorMessage;
  String get currentQuery => _currentQuery;

  Future<void> loadStoredData() async {
    _favorites = await _storageService.getFavorites();
    _history = await _storageService.getSearchHistory();
    notifyListeners();
  }

  Future<void> search(String query) async {
    _currentQuery = query;
    final trimmed = query.trim();

    if (trimmed.isEmpty) {
      _searchResults = [];
      _isSearching = false;
      _errorMessage = null;
      notifyListeners();
      return;
    }

    _isSearching = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _searchResults = await _apiService.searchLocations(trimmed);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _searchResults = [];
    } finally {
      _isSearching = false;
      notifyListeners();
    }
  }

  Future<void> toggleFavorite(LocationModel location) async {
    final exists = _favorites.any((item) => item == location);
    if (exists) {
      await _storageService.removeFavorite(location);
    } else {
      await _storageService.saveFavorite(location);
    }
    _favorites = await _storageService.getFavorites();
    notifyListeners();
  }

  bool isLocationFavorite(LocationModel location) {
    return _favorites.any((item) => item == location);
  }

  Future<void> clearHistory() async {
    await _storageService.clearSearchHistory();
    _history = [];
    notifyListeners();
  }

  void clearSearch() {
    _currentQuery = '';
    _searchResults = [];
    _isSearching = false;
    _errorMessage = null;
    notifyListeners();
  }
}
