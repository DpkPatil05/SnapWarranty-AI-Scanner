import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/initialization/app_initializers.dart';
import 'presentation/app.dart';

/// The Entry Point of the application.
///
/// Following the modular architecture refactor, all heavy setup logic
/// (Firebase, Drive Auth, .env, Notifications) has been moved
/// to [AppInitializers] in the core layer.
void main() async {
  // Execute the boot sequence
  await AppInitializers.init();

  // Launch the App within a ProviderScope for Riverpod 3.x state management
  runApp(const ProviderScope(child: SnapWarrantyApp()));
}
