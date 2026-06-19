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
          seedColor: const Color(0xFF6366F1),
          brightness: Brightness.dark,
        ),
      ),
      home: const HomePage(),
    );
  }
}
