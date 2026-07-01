import 'package:firebase_analytics/firebase_analytics.dart';

import '../../domain/analytics/analytics_service_interface.dart';
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
    await logEvent('scan_started', parameters: {'source': source});
  }

  @override
  Future<void> logScanCompleted(String productName, bool success) async {
    await logEvent(
      'scan_completed',
      parameters: {'product_name': productName, 'success': success ? 1 : 0},
    );
  }

  @override
  Future<void> logAdImpression(String adType) async {
    await logEvent('ad_impression', parameters: {'ad_type': adType});
  }

  @override
  Future<void> logSyncStarted() async {
    await logEvent('sync_started');
  }

  @override
  Future<void> logSyncCompleted(bool success) async {
    await logEvent('sync_completed', parameters: {'success': success ? 1 : 0});
  }

  @override
  Future<void> logWarrantyViewed(String id, String name) async {
    await logEvent(
      'view_warranty',
      parameters: {'warranty_id': id, 'product_name': name},
    );
  }

  @override
  Future<void> logWarrantyDeleted(String id, String name) async {
    await logEvent(
      'delete_warranty',
      parameters: {'warranty_id': id, 'product_name': name},
    );
  }

  @override
  Future<void> logWarrantyUpdated(String id, String name) async {
    await logEvent(
      'update_warranty',
      parameters: {'warranty_id': id, 'product_name': name},
    );
  }

  @override
  Future<void> logSearchPerformed(String query) async {
    if (query.isEmpty) return;
    await logEvent('search_performed', parameters: {'search_query': query});
  }

  @override
  Future<void> logNotificationScheduled(String id, String name) async {
    await logEvent(
      'notification_scheduled',
      parameters: {'warranty_id': id, 'product_name': name},
    );
  }

  @override
  Future<void> logAppUpdatePrompted(String version) async {
    await logEvent(
      'app_update_prompted',
      parameters: {'target_version': version},
    );
  }

  @override
  Future<void> logError(String message, String source) async {
    await logEvent(
      'app_error',
      parameters: {'error_message': message, 'error_source': source},
    );
  }

  @override
  Future<void> logImageExported(String id, String name) async {
    await logEvent(
      'image_exported',
      parameters: {'warranty_id': id, 'product_name': name},
    );
  }
}
