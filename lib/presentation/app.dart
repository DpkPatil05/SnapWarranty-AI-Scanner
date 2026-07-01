import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pages/home/home_page.dart';
import 'pages/walkthrough/walkthrough_page.dart';

class SnapWarrantyApp extends StatelessWidget {
  const SnapWarrantyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SnapWarranty: AI Scanner',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1), // Modern Indigo
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
        ),
      ),
      home: FutureBuilder<bool>(
        future: _checkFirstLaunch(),
        builder: (context, snapshot) {
          // While checking prefs, show a plain black screen (Splash is handling this transition)
          if (!snapshot.hasData) {
            return const Scaffold(backgroundColor: Color(0xFF0F172A));
          }

          final bool hasSeenWalkthrough = snapshot.data ?? false;

          if (hasSeenWalkthrough) {
            return const HomePage();
          } else {
            return const WalkthroughPage();
          }
        },
      ),
    );
  }

  Future<bool> _checkFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('has_seen_walkthrough') ?? false;
  }
}
