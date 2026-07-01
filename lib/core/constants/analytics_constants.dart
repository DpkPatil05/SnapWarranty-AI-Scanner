class AnalyticsEvents {
  static const String scanStarted = 'scan_started';
  static const String scanCompleted = 'scan_completed';
  static const String adImpression = 'ad_impression';
  static const String syncStarted = 'sync_started';
  static const String syncCompleted = 'sync_completed';
  static const String viewWarranty = 'view_warranty';
  static const String deleteWarranty = 'delete_warranty';
  static const String updateWarranty = 'update_warranty';
  static const String searchPerformed = 'search_performed';
  static const String notificationScheduled = 'notification_scheduled';
  static const String appUpdatePrompted = 'app_update_prompted';
  static const String appError = 'app_error';
  static const String imageExported = 'image_exported';
}

class AnalyticsParams {
  static const String source = 'source';
  static const String productName = 'product_name';
  static const String success = 'success';
  static const String adType = 'ad_type';
  static const String warrantyId = 'warranty_id';
  static const String searchQuery = 'search_query';
  static const String targetVersion = 'target_version';
  static const String errorMessage = 'error_message';
  static const String errorSource = 'error_source';
}
