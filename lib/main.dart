import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'data/datasources/local/database/app_database.dart';
import 'presentation/state/warranty_provider.dart';
import 'presentation/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load the environment variables BEFORE anything else
  await dotenv.load(fileName: ".env");

  // Initialize the Floor SQLite database
  final database = await $FloorAppDatabase
      .databaseBuilder('app_database.db')
      .build();

  runApp(
    ProviderScope(
      overrides: [databaseProvider.overrideWithValue(database)],
      child: const SnapWarrantyApp(),
    ),
  );
}
