// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'SnapWarranty';

  @override
  String get appSubtitle => 'Your digital warranty vault';

  @override
  String get addDocument => 'Add Document';

  @override
  String get vaultSettings => 'Vault Settings';

  @override
  String get cloudBackup => 'Cloud Backup';

  @override
  String get backupDescription =>
      'Upload your receipts to Google Drive. This keeps your vault safe if you lose your phone.';

  @override
  String get backupToDrive => 'Backup to Drive';

  @override
  String get backingUp => 'Backing up...';

  @override
  String get restoreVault => 'Restore Vault';

  @override
  String get restoreDescription =>
      'Recover your warranties and images from a previous backup on Google Drive.';

  @override
  String get restoreFromDrive => 'Restore from Drive';

  @override
  String get restoring => 'Restoring...';

  @override
  String get reminders => 'Reminders';

  @override
  String get remindersDescription =>
      'Get notified 30 days before and on the day your warranty expires.';

  @override
  String get managePermissions => 'Manage Permissions';

  @override
  String get supportUs => 'Support Us';

  @override
  String get supportDescription =>
      'Enjoying Snap Warranty? Rate us on the store to help others find us!';

  @override
  String get rateAndReview => 'Rate & Review';

  @override
  String version(String version) {
    return 'Version $version';
  }

  @override
  String get search => 'Search warranties...';

  @override
  String get selectSource => 'Select Source';

  @override
  String get camera => 'Camera';

  @override
  String get gallery => 'Gallery';

  @override
  String get pdf => 'PDF';

  @override
  String get privateSecure => 'Private & Secure';

  @override
  String get privateSecureDesc => 'Only you can access your Drive data.';

  @override
  String get encryptedSync => 'Encrypted Sync';

  @override
  String get encryptedSyncDesc => 'Metadata is handled securely via OAuth2.';

  @override
  String get backupComplete => 'Backup complete!';

  @override
  String get restoreComplete => 'Restore complete!';

  @override
  String get aiBusy =>
      'The AI service is currently under high demand. Please try again in a few moments.';

  @override
  String get scanFailed =>
      'We couldn\'t read your document. Please make sure the photo is clear and try again.';

  @override
  String error(String message) {
    return 'Error: $message';
  }

  @override
  String get noWarranties => 'No documents found';

  @override
  String get scanFirst => 'Scan your first receipt to start tracking!';

  @override
  String get delete => 'Delete';

  @override
  String get confirmDelete => 'Are you sure you want to delete this warranty?';

  @override
  String get language => 'Language';

  @override
  String get systemDefault => 'System Default';

  @override
  String get english => 'English';

  @override
  String get hindi => 'Hindi';

  @override
  String get marathi => 'Marathi';

  @override
  String expires(String date) {
    return 'Expires: $date';
  }

  @override
  String get expiryNotSet => 'Expiry not set';

  @override
  String get product => 'Product';

  @override
  String get purchaseDate => 'Purchase Date';

  @override
  String get warrantyDuration => 'Warranty Duration';

  @override
  String get expirationDate => 'Expiration Date';

  @override
  String months(int count) {
    return '$count Months';
  }

  @override
  String get setExpirationDate => 'Set Expiration Date';

  @override
  String get durationNotFound => 'Duration not found in document';

  @override
  String get expirationUpdated => 'Expiration updated!';

  @override
  String get deleteWarranty => 'Delete Warranty?';

  @override
  String confirmRemove(String product) {
    return 'Are you sure you want to remove $product from your vault?';
  }
}
