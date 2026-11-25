import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsi_flutter/utils/app_theme.dart';
import 'package:responsi_flutter/viewmodels/search_viewmodel.dart';
import 'package:responsi_flutter/viewmodels/weather_viewmodel.dart';
import 'package:responsi_flutter/views/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WeatherViewModel()),
        ChangeNotifierProvider(create: (_) => SearchViewModel()),
      ],
      child: MaterialApp(
        title: 'Aplikasi Cuaca',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const HomeScreen(),
      ),
    );
  }
}
