import 'package:flutter/material.dart';
import 'pages/home_page.dart';

class SnapWarrantyApp extends StatelessWidget {
  const SnapWarrantyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SnapWarranty',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
