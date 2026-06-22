import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import '../../firebase_options.dart';
import '../../data/datasources/local/notification_service.dart';
import '../../data/datasources/remote/drive/drive_sync_datasource.dart';
import 'dart:developer' as dev;

class AppInitializers {
  /// Entry point for all core service initializations.
  /// This ensures main.dart remains clean and focused only on the widget tree.
  static Future<void> init() async {
    try {
      dev.log('Starting boot sequence...', name: 'AppInitializers');

      // 1. Ensure Flutter bindings are ready
      WidgetsFlutterBinding.ensureInitialized();

      // 2. Load Environment Variables (.env)
      await _initDotEnv();

      // 3. Initialize Firebase & App Check
      await _initFirebase();

      // 4. Restore Drive Session (Persistent Auth)
      await _initDriveAuth();

      // 5. Initialize Local Notification System
      await _initNotifications();

      dev.log('Boot sequence complete!', name: 'AppInitializers');
    } catch (e, st) {
      dev.log(
        'CRITICAL BOOT ERROR',
        name: 'AppInitializers',
        error: e,
        stackTrace: st,
      );
      rethrow;
    }
  }

  static Future<void> _initDotEnv() async {
    dev.log('Loading .env file...', name: 'AppInitializers');
    await dotenv.load(fileName: ".env");
  }

  static Future<void> _initFirebase() async {
    dev.log('Initializing Firebase...', name: 'AppInitializers');
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    dev.log('Activating App Check...', name: 'AppInitializers');
    await FirebaseAppCheck.instance.activate(
      // NOTE: Change to AndroidPlayIntegrityProvider() before publishing to Play Store
      providerAndroid: AndroidDebugProvider(),
      providerApple: AppleAppAttestProvider(),
    );
  }

  static Future<void> _initDriveAuth() async {
    dev.log('Restoring Drive session...', name: 'AppInitializers');
    // Using instance.silentSignIn() to match the optimized persistence logic
    await DriveSyncDataSource().silentSignIn();
  }

  static Future<void> _initNotifications() async {
    dev.log('Initializing Notifications...', name: 'AppInitializers');
    await NotificationService().initialize();
  }
}
