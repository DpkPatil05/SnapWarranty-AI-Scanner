abstract class IAnalyticsService {
  Future<void> logScanStarted(String source);

  Future<void> logScanCompleted(String productName, bool success);

  Future<void> logAdImpression(String adType);

  Future<void> logSyncStarted();

  Future<void> logSyncCompleted(bool success);

  Future<void> logWarrantyViewed(String id, String name);

  Future<void> logWarrantyDeleted(String id, String name);

  Future<void> logWarrantyUpdated(String id, String name);

  Future<void> logSearchPerformed(String query);

  Future<void> logNotificationScheduled(String id, String name);

  Future<void> logAppUpdatePrompted(String version);

  Future<void> logError(String message, String source);

  Future<void> logImageExported(String id, String name);
}
