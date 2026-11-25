import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsi_flutter/viewmodels/weather_viewmodel.dart';
import 'package:responsi_flutter/views/search_screen.dart';
import 'package:responsi_flutter/views/widgets/current_weather_card.dart';
import 'package:responsi_flutter/views/widgets/daily_forecast_list.dart';
import 'package:responsi_flutter/views/widgets/weather_metrics_grid.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WeatherViewModel>().initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cuaca Terkini'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded),
            tooltip: 'Cari Kota / Lokasi',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchScreen()),
              );
            },
          ),
        ],
      ),
      body: Consumer<WeatherViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading && !viewModel.hasData) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text(
                    'Memuat data cuaca...',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          if (viewModel.errorMessage != null && !viewModel.hasData) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.cloud_off_rounded,
                      color: Colors.redAccent,
                      size: 64,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Gagal Memuat Cuaca',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1C274C),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      viewModel.errorMessage!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () => viewModel.fetchWeather(),
                      icon: const Icon(Icons.refresh_rounded),
                      label: const Text('Coba Lagi'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E88E5),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          final weather = viewModel.weather;
          if (weather == null) {
            return const Center(child: Text('Data cuaca tidak tersedia'));
          }

          return RefreshIndicator(
            onRefresh: () => viewModel.fetchWeather(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CurrentWeatherCard(
                    location: viewModel.currentLocation,
                    current: weather.current,
                    isFavorite: viewModel.isFavorite,
                    onToggleFavorite: () => viewModel.toggleFavorite(),
                  ),
                  const SizedBox(height: 20),
                  WeatherMetricsGrid(current: weather.current),
                  const SizedBox(height: 20),
                  DailyForecastList(forecasts: weather.daily),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
