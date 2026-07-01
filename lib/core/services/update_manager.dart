import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';

class UpdateManager {
  static Future<void> evaluateAndPromptUpdate() async {
    try {
      final remoteConfig = FirebaseRemoteConfig.instance;

      await remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 10),
          minimumFetchInterval: const Duration(hours: 12),
        ),
      );

      await remoteConfig.setDefaults(const {'force_app_update': true});
      await remoteConfig.fetchAndActivate();

      if (remoteConfig.getBool('force_app_update')) {
        debugPrint(
          "Remote Config: Force update is ENABLED. Checking Play Store...",
        );
        final AppUpdateInfo info = await InAppUpdate.checkForUpdate();
        if (info.updateAvailability == UpdateAvailability.updateAvailable) {
          await InAppUpdate.performImmediateUpdate();
        }
      }
    } catch (e) {
      debugPrint("Update check failed: \$e");
    }
  }
}
