import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'data/datasources/local/database/app_database.dart';
import 'presentation/state/warranty_provider.dart';
import 'presentation/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the Floor SQLite database
  final database = await $FloorAppDatabase
      .databaseBuilder('app_database.db')
      .build();

  runApp(
    ProviderScope(
      overrides: [
        // Inject the built database into our Riverpod tree
        databaseProvider.overrideWithValue(database),
      ],
      child: const SnapWarrantyApp(),
    ),
  );
}

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
