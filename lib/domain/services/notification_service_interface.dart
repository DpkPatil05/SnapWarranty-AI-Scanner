abstract class INotificationService {
  Future<void> initialize();

  Future<void> requestPermissions();

  Future<void> scheduleExpiryReminder({
    required String id,
    required String productName,
    required DateTime expirationDate,
  });

  Future<void> cancelReminder(String id);
}
