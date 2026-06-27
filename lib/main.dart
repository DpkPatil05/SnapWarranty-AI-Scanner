import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/initialization/app_initializers.dart';
import 'presentation/app.dart';

/// The Entry Point of the application.
void main() async {
  try {
    // 1. Ensure Flutter bindings are ready
    WidgetsFlutterBinding.ensureInitialized();

    // 2. Execute the boot sequence
    AppInitializers.init();
  } catch (e, st) {
    debugPrint('FATAL INITIALIZATION ERROR: $e');
    debugPrint(st.toString());
  }

  // Launch the App within a ProviderScope for Riverpod 3.x state management
  runApp(const ProviderScope(child: SnapWarrantyApp()));
}
