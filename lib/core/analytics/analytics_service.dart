import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  AnalyticsService._internal();

  static final AnalyticsService instance = AnalyticsService._internal();

  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  Future<void> logEvent(String name, {Map<String, Object>? parameters}) async {
    await _analytics.logEvent(name: name, parameters: parameters);
  }

  Future<void> logScanStarted(String source) async {
    await logEvent('scan_started', parameters: {'source': source});
  }

  Future<void> logScanCompleted(String productName, bool success) async {
    await logEvent(
      'scan_completed',
      parameters: {'product_name': productName, 'success': success ? 1 : 0},
    );
  }

  Future<void> logSyncStarted() async {
    await logEvent('sync_started');
  }

  Future<void> logSyncCompleted(bool success) async {
    await logEvent('sync_completed', parameters: {'success': success ? 1 : 0});
  }

  Future<void> logWarrantyViewed(String id, String name) async {
    await logEvent(
      'view_warranty',
      parameters: {'warranty_id': id, 'product_name': name},
    );
  }
}
