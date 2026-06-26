abstract class IAnalyticsService {
  Future<void> logScanStarted(String source);

  Future<void> logScanCompleted(String productName, bool success);

  Future<void> logAdImpression(String adType);

  Future<void> logSyncStarted();

  Future<void> logSyncCompleted(bool success);

  Future<void> logWarrantyViewed(String id, String name);
}
