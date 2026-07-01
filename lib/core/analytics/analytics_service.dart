import 'package:firebase_analytics/firebase_analytics.dart';

import '../../domain/analytics/analytics_service_interface.dart';
import '../constants/analytics_constants.dart';
import '../initialization/app_initializers.dart';

class AnalyticsService implements IAnalyticsService {
  AnalyticsService._internal();

  static final AnalyticsService instance = AnalyticsService._internal();

  FirebaseAnalytics get _analytics => FirebaseAnalytics.instance;

  Future<void> logEvent(String name, {Map<String, Object>? parameters}) async {
    await AppInitializers.isReady;
    await _analytics.logEvent(name: name, parameters: parameters);
  }

  @override
  Future<void> logScanStarted(String source) async {
    await logEvent(
      AnalyticsEvents.scanStarted,
      parameters: {AnalyticsParams.source: source},
    );
  }

  @override
  Future<void> logScanCompleted(String productName, bool success) async {
    await logEvent(
      AnalyticsEvents.scanCompleted,
      parameters: {
        AnalyticsParams.productName: productName,
        AnalyticsParams.success: success ? 1 : 0,
      },
    );
  }

  @override
  Future<void> logAdImpression(String adType) async {
    await logEvent(
      AnalyticsEvents.adImpression,
      parameters: {AnalyticsParams.adType: adType},
    );
  }

  @override
  Future<void> logSyncStarted() async {
    await logEvent(AnalyticsEvents.syncStarted);
  }

  @override
  Future<void> logSyncCompleted(bool success) async {
    await logEvent(
      AnalyticsEvents.syncCompleted,
      parameters: {AnalyticsParams.success: success ? 1 : 0},
    );
  }

  @override
  Future<void> logWarrantyViewed(String id, String name) async {
    await logEvent(
      AnalyticsEvents.viewWarranty,
      parameters: {
        AnalyticsParams.warrantyId: id,
        AnalyticsParams.productName: name,
      },
    );
  }

  @override
  Future<void> logWarrantyDeleted(String id, String name) async {
    await logEvent(
      AnalyticsEvents.deleteWarranty,
      parameters: {
        AnalyticsParams.warrantyId: id,
        AnalyticsParams.productName: name,
      },
    );
  }

  @override
  Future<void> logWarrantyUpdated(String id, String name) async {
    await logEvent(
      AnalyticsEvents.updateWarranty,
      parameters: {
        AnalyticsParams.warrantyId: id,
        AnalyticsParams.productName: name,
      },
    );
  }

  @override
  Future<void> logSearchPerformed(String query) async {
    if (query.isEmpty) return;
    await logEvent(
      AnalyticsEvents.searchPerformed,
      parameters: {AnalyticsParams.searchQuery: query},
    );
  }

  @override
  Future<void> logNotificationScheduled(String id, String name) async {
    await logEvent(
      AnalyticsEvents.notificationScheduled,
      parameters: {
        AnalyticsParams.warrantyId: id,
        AnalyticsParams.productName: name,
      },
    );
  }

  @override
  Future<void> logAppUpdatePrompted(String version) async {
    await logEvent(
      AnalyticsEvents.appUpdatePrompted,
      parameters: {AnalyticsParams.targetVersion: version},
    );
  }

  @override
  Future<void> logError(String message, String source) async {
    await logEvent(
      AnalyticsEvents.appError,
      parameters: {
        AnalyticsParams.errorMessage: message,
        AnalyticsParams.errorSource: source,
      },
    );
  }

  @override
  Future<void> logImageExported(String id, String name) async {
    await logEvent(
      AnalyticsEvents.imageExported,
      parameters: {
        AnalyticsParams.warrantyId: id,
        AnalyticsParams.productName: name,
      },
    );
  }
}
