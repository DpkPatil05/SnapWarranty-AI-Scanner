import 'package:firebase_analytics/firebase_analytics.dart';
import '../../domain/analytics/analytics_service_interface.dart';

class AnalyticsService implements IAnalyticsService {
  AnalyticsService._internal();

  static final AnalyticsService instance = AnalyticsService._internal();

  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  Future<void> logEvent(String name, {Map<String, Object>? parameters}) async {
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
}
