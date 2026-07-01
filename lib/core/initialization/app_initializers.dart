import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import '../ads/ad_service.dart';
import '../config/remote_config_service.dart';
import '../../firebase_options.dart';
import '../../data/datasources/local/notification_service.dart';
import '../../data/datasources/remote/drive/drive_sync_datasource.dart';
import 'dart:developer' as dev;

class AppInitializers {
  /// Entry point for all core service initializations.
  static Future<void> init() async {
    try {
      dev.log('Starting boot sequence...', name: 'AppInitializers');

      // 1. Initialize Firebase & App Check
      await _initFirebase();

      // 2. Restore Drive Session (Persistent Auth)
      await _initDriveAuth();

      // 3. Initialize Local Notification System
      await _initNotifications();

      // 4. Initialize Mobile Ads
      await _initMobileAds();

      // 5. Initialize Remote Config
      await _initRemoteConfig();

      dev.log('Boot sequence complete!', name: 'AppInitializers');
    } catch (e, st) {
      dev.log(
        'CRITICAL BOOT ERROR',
        name: 'AppInitializers',
        error: e,
        stackTrace: st,
      );
      rethrow;
    } finally {
      // Ensure splash is always removed, even on error
      FlutterNativeSplash.remove();
    }
  }

  static Future<void> _initFirebase() async {
    dev.log('Initializing Firebase...', name: 'AppInitializers');
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    dev.log('Activating App Check...', name: 'AppInitializers');
    await FirebaseAppCheck.instance.activate(
      providerAndroid: AndroidPlayIntegrityProvider(),
      providerApple: AppleAppAttestProvider(),
    );
  }

  static Future<void> _initDriveAuth() async {
    dev.log('Restoring Drive session...', name: 'AppInitializers');
    await DriveSyncDataSource.instance.restoreSession();
  }

  static Future<void> _initNotifications() async {
    dev.log('Initializing Notifications...', name: 'AppInitializers');
    await NotificationService().initialize();
  }

  static Future<void> _initMobileAds() async {
    dev.log('Initializing Mobile Ads...', name: 'AppInitializers');
    await MobileAds.instance.initialize();
    AdService.instance.init();
  }

  static Future<void> _initRemoteConfig() async {
    dev.log('Initializing Remote Config...', name: 'AppInitializers');
    await RemoteConfigService.instance.init();
  }
}
