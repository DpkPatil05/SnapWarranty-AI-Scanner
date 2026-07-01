import 'dart:developer' as dev;

import 'package:firebase_remote_config/firebase_remote_config.dart';

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
          minimumFetchInterval: const Duration(hours: 1),
        ),
      );
      await _remoteConfig.fetchAndActivate();
    } catch (e) {
      dev.log('Remote Config init failed: $e', name: 'RemoteConfigService');
    }
  }

  int get interstitialAdFrequency =>
      _remoteConfig.getInt(AppConstants.keyAdFrequency);

  String get geminiApiKey =>
      _remoteConfig.getString(AppConstants.keyGeminiApiKey);

  bool get isForceUpdateEnabled =>
      _remoteConfig.getBool(AppConstants.keyForceUpdate);
}
