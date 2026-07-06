import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_mr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hi'),
    Locale('mr'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'SnapWarranty'**
  String get appTitle;

  /// No description provided for @addDocument.
  ///
  /// In en, this message translates to:
  /// **'Add Document'**
  String get addDocument;

  /// No description provided for @vaultSettings.
  ///
  /// In en, this message translates to:
  /// **'Vault Settings'**
  String get vaultSettings;

  /// No description provided for @cloudBackup.
  ///
  /// In en, this message translates to:
  /// **'Cloud Backup'**
  String get cloudBackup;

  /// No description provided for @backupDescription.
  ///
  /// In en, this message translates to:
  /// **'Upload your receipts to Google Drive. This keeps your vault safe if you lose your phone.'**
  String get backupDescription;

  /// No description provided for @backupToDrive.
  ///
  /// In en, this message translates to:
  /// **'Backup to Drive'**
  String get backupToDrive;

  /// No description provided for @backingUp.
  ///
  /// In en, this message translates to:
  /// **'Backing up...'**
  String get backingUp;

  /// No description provided for @restoreVault.
  ///
  /// In en, this message translates to:
  /// **'Restore Vault'**
  String get restoreVault;

  /// No description provided for @restoreDescription.
  ///
  /// In en, this message translates to:
  /// **'Recover your warranties and images from a previous backup on Google Drive.'**
  String get restoreDescription;

  /// No description provided for @restoreFromDrive.
  ///
  /// In en, this message translates to:
  /// **'Restore from Drive'**
  String get restoreFromDrive;

  /// No description provided for @restoring.
  ///
  /// In en, this message translates to:
  /// **'Restoring...'**
  String get restoring;

  /// No description provided for @reminders.
  ///
  /// In en, this message translates to:
  /// **'Reminders'**
  String get reminders;

  /// No description provided for @remindersDescription.
  ///
  /// In en, this message translates to:
  /// **'Get notified 30 days before and on the day your warranty expires.'**
  String get remindersDescription;

  /// No description provided for @managePermissions.
  ///
  /// In en, this message translates to:
  /// **'Manage Permissions'**
  String get managePermissions;

  /// No description provided for @supportUs.
  ///
  /// In en, this message translates to:
  /// **'Support Us'**
  String get supportUs;

  /// No description provided for @supportDescription.
  ///
  /// In en, this message translates to:
  /// **'Enjoying Snap Warranty? Rate us on the store to help others find us!'**
  String get supportDescription;

  /// No description provided for @rateAndReview.
  ///
  /// In en, this message translates to:
  /// **'Rate & Review'**
  String get rateAndReview;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String version(String version);

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search warranties...'**
  String get search;

  /// No description provided for @selectSource.
  ///
  /// In en, this message translates to:
  /// **'Select Source'**
  String get selectSource;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @pdf.
  ///
  /// In en, this message translates to:
  /// **'PDF'**
  String get pdf;

  /// No description provided for @privateSecure.
  ///
  /// In en, this message translates to:
  /// **'Private & Secure'**
  String get privateSecure;

  /// No description provided for @privateSecureDesc.
  ///
  /// In en, this message translates to:
  /// **'Only you can access your Drive data.'**
  String get privateSecureDesc;

  /// No description provided for @encryptedSync.
  ///
  /// In en, this message translates to:
  /// **'Encrypted Sync'**
  String get encryptedSync;

  /// No description provided for @encryptedSyncDesc.
  ///
  /// In en, this message translates to:
  /// **'Metadata is handled securely via OAuth2.'**
  String get encryptedSyncDesc;

  /// No description provided for @backupComplete.
  ///
  /// In en, this message translates to:
  /// **'Backup complete!'**
  String get backupComplete;

  /// No description provided for @restoreComplete.
  ///
  /// In en, this message translates to:
  /// **'Restore complete!'**
  String get restoreComplete;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error: {message}'**
  String error(String message);

  /// No description provided for @noWarranties.
  ///
  /// In en, this message translates to:
  /// **'No documents found'**
  String get noWarranties;

  /// No description provided for @scanFirst.
  ///
  /// In en, this message translates to:
  /// **'Scan your first receipt to start tracking!'**
  String get scanFirst;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @confirmDelete.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this warranty?'**
  String get confirmDelete;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @systemDefault.
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get systemDefault;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @hindi.
  ///
  /// In en, this message translates to:
  /// **'Hindi'**
  String get hindi;

  /// No description provided for @marathi.
  ///
  /// In en, this message translates to:
  /// **'Marathi'**
  String get marathi;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'hi', 'mr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
    case 'mr':
      return AppLocalizationsMr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
