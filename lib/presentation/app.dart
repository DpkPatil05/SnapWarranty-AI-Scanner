import 'package:flutter/material.dart';
import 'pages/home/home_page.dart';

class SnapWarrantyApp extends StatelessWidget {
  const SnapWarrantyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SnapWarranty',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1), // Modern Indigo
          brightness: Brightness.dark,
        ),
        // Deep background to allow Liquid Glass blur effects to stand out
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
        ),
      ),
      home: const HomePage(),
    );
  }
}
