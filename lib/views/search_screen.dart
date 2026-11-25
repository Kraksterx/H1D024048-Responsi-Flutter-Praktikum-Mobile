import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsi_flutter/models/location_model.dart';
import 'package:responsi_flutter/viewmodels/search_viewmodel.dart';
import 'package:responsi_flutter/viewmodels/weather_viewmodel.dart';
import 'package:responsi_flutter/views/widgets/search_location_tile.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vm = context.read<SearchViewModel>();
      vm.loadStoredData();
      vm.clearSearch();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onLocationSelected(LocationModel location) {
    context.read<WeatherViewModel>().selectLocation(location);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cari Lokasi'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Consumer<SearchViewModel>(
              builder: (context, searchVM, child) {
                return TextField(
                  controller: _searchController,
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText: 'Ketik nama kota (misal: Bandung, Tokyo)...',
                    prefixIcon: const Icon(Icons.search_rounded),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear_rounded),
                            onPressed: () {
                              _searchController.clear();
                              searchVM.clearSearch();
                            },
                          )
                        : null,
                  ),
                  onChanged: (value) {
                    setState(() {});
                    searchVM.search(value);
                  },
                  onSubmitted: (value) {
                    searchVM.search(value);
                  },
                );
              },
            ),
          ),
          Expanded(
            child: Consumer<SearchViewModel>(
              builder: (context, searchVM, child) {
                if (searchVM.isSearching) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 12),
                        Text(
                          'Mencari lokasi...',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }

                if (searchVM.errorMessage != null) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline_rounded,
                            color: Colors.redAccent,
                            size: 48,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            searchVM.errorMessage!,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey.shade700),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (_searchController.text.trim().isNotEmpty) {
                  final results = searchVM.searchResults;
                  if (results.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.location_off_outlined,
                              color: Colors.grey.shade400,
                              size: 56,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Kota tidak ditemukan',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Coba periksa kembali ejaan nama kota Anda',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: results.length,
                    itemBuilder: (context, index) {
                      final location = results[index];
                      final isFav = searchVM.isLocationFavorite(location);
                      return SearchLocationTile(
                        location: location,
                        isFavorite: isFav,
                        onTap: () => _onLocationSelected(location),
                        onToggleFavorite: () =>
                            searchVM.toggleFavorite(location),
                      );
                    },
                  );
                }

                return _buildDefaultContent(searchVM);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultContent(SearchViewModel searchVM) {
    final favorites = searchVM.favorites;
    final history = searchVM.history;

    if (favorites.isEmpty && history.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.travel_explore_rounded,
                size: 64,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 16),
              const Text(
                'Cari Kota Impian Anda',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1C274C),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Gunakan kolom pencarian di atas untuk memeriksa kondisi cuaca di berbagai wilayah.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView(
      children: [
        if (favorites.isNotEmpty) ...[
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Row(
              children: [
                const Icon(
                  Icons.favorite_rounded,
                  color: Colors.redAccent,
                  size: 20,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Lokasi Favorit',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1C274C),
                  ),
                ),
                const Spacer(),
                Text(
                  '${favorites.length} kota',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
          ...favorites.map((location) {
            return SearchLocationTile(
              location: location,
              isFavorite: true,
              onTap: () => _onLocationSelected(location),
              onToggleFavorite: () => searchVM.toggleFavorite(location),
            );
          }),
          const SizedBox(height: 16),
        ],
        if (history.isNotEmpty) ...[
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Row(
              children: [
                const Icon(
                  Icons.history_rounded,
                  color: Color(0xFF1E88E5),
                  size: 20,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Riwayat Pencarian',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1C274C),
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => searchVM.clearHistory(),
                  child: const Text(
                    'Hapus Semua',
                    style: TextStyle(fontSize: 12, color: Colors.redAccent),
                  ),
                ),
              ],
            ),
          ),
          ...history.map((location) {
            final isFav = searchVM.isLocationFavorite(location);
            return SearchLocationTile(
              location: location,
              isFavorite: isFav,
              onTap: () => _onLocationSelected(location),
              onToggleFavorite: () => searchVM.toggleFavorite(location),
            );
          }),
          const SizedBox(height: 24),
        ],
      ],
    );
  }
}
