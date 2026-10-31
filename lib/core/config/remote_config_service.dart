import 'dart:developer' as dev;

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';

import '../constants/app_constants.dart';
import '../initialization/app_initializers.dart';

class RemoteConfigService {
  RemoteConfigService._internal();

  static final RemoteConfigService instance = RemoteConfigService._internal();

  FirebaseRemoteConfig get _remoteConfig => FirebaseRemoteConfig.instance;

  Future<void> init() async {
    await AppInitializers.isReady;
    try {
      await _remoteConfig.setDefaults({
        AppConstants.keyAdFrequency: 3,
        AppConstants.keyGeminiApiKey: '',
        AppConstants.keyForceUpdate: false,
      });

      await _remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(minutes: 1),
          // In debug mode, fetch immediately so changes in Firebase Console apply without waiting 1 hour
          minimumFetchInterval: kDebugMode
              ? Duration.zero
              : const Duration(hours: 1),
        ),
      );
      final activated = await _remoteConfig.fetchAndActivate();
      dev.log(
        'Remote Config initialized (activated new config: $activated)',
        name: 'RemoteConfigService',
      );
    } catch (e) {
      dev.log('Remote Config init failed: $e', name: 'RemoteConfigService');
    }
  }

  int get interstitialAdFrequency =>
      _remoteConfig.getInt(AppConstants.keyAdFrequency);

  String get geminiApiKey {
    const envKey = String.fromEnvironment('GEMINI_API_KEY');
    if (envKey.isNotEmpty) return envKey.trim();

    final raw = _remoteConfig.getString(AppConstants.keyGeminiApiKey).trim();
    // Strip accidental quotes if pasted wrapped in quotes
    if ((raw.startsWith('"') && raw.endsWith('"')) ||
        (raw.startsWith("'") && raw.endsWith("'"))) {
      return raw.substring(1, raw.length - 1).trim();
    }
    return raw;
  }

  bool get isForceUpdateEnabled =>
      _remoteConfig.getBool(AppConstants.keyForceUpdate);
}
