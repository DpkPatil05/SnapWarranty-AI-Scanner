import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'dart:developer' as dev;

class RemoteConfigService {
  RemoteConfigService._internal();
  static final RemoteConfigService instance = RemoteConfigService._internal();

  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

  static const String keyAdFrequency = 'interstitial_ad_frequency';

  Future<void> init() async {
    try {
      await _remoteConfig.setDefaults({keyAdFrequency: 3});
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

  int get interstitialAdFrequency => _remoteConfig.getInt(keyAdFrequency);
}
