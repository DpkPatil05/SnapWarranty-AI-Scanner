// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'स्नैपवॉरंटी';

  @override
  String get addDocument => 'दस्तावेज़ जोड़ें';

  @override
  String get vaultSettings => 'वॉल्ट सेटिंग्स';

  @override
  String get cloudBackup => 'क्लाउड बैकअप';

  @override
  String get backupDescription =>
      'अपनी रसीदें Google Drive पर अपलोड करें। यह आपके फोन खो जाने पर भी आपके वॉल्ट को सुरक्षित रखता है।';

  @override
  String get backupToDrive => 'ड्राइव पर बैकअप लें';

  @override
  String get backingUp => 'बैकअप लिया जा रहा है...';

  @override
  String get restoreVault => 'वॉल्ट पुनर्स्थापित करें';

  @override
  String get restoreDescription =>
      'Google Drive पर पिछले बैकअप से अपनी वारंटी और चित्र पुनर्प्राप्त करें।';

  @override
  String get restoreFromDrive => 'ड्राइव से पुनर्स्थापित करें';

  @override
  String get restoring => 'पुनर्स्थापित किया जा रहा है...';

  @override
  String get reminders => 'रिमाइंडर';

  @override
  String get remindersDescription =>
      'वारंटी समाप्त होने के 30 दिन पहले और उसी दिन सूचना प्राप्त करें।';

  @override
  String get managePermissions => 'अनुमतियां प्रबंधित करें';

  @override
  String get supportUs => 'हमारा समर्थन करें';

  @override
  String get supportDescription =>
      'स्नैप वारंटी का आनंद ले रहे हैं? दूसरों को हमें खोजने में मदद करने के लिए स्टोर पर हमें रेट करें!';

  @override
  String get rateAndReview => 'रेट और समीक्षा करें';

  @override
  String version(String version) {
    return 'संस्करण $version';
  }

  @override
  String get search => 'वारंटी खोजें...';

  @override
  String get selectSource => 'स्रोत चुनें';

  @override
  String get camera => 'कैमरा';

  @override
  String get gallery => 'गैलरी';

  @override
  String get pdf => 'पीडीएफ';

  @override
  String get privateSecure => 'निजी और सुरक्षित';

  @override
  String get privateSecureDesc =>
      'केवल आप ही अपने ड्राइव डेटा तक पहुंच सकते हैं।';

  @override
  String get encryptedSync => 'एन्क्रिप्टेड सिंक';

  @override
  String get encryptedSyncDesc =>
      'मेटाडेटा OAuth2 के माध्यम से सुरक्षित रूप से संभाला जाता है।';

  @override
  String get backupComplete => 'बैकअप पूरा हुआ!';

  @override
  String get restoreComplete => 'पुनर्स्थापना पूरी हुई!';

  @override
  String error(String message) {
    return 'त्रुटि: $message';
  }

  @override
  String get noWarranties => 'कोई दस्तावेज़ नहीं मिला';

  @override
  String get scanFirst =>
      'ट्रैकिंग शुरू करने के लिए अपनी पहली रसीद स्कैन करें!';

  @override
  String get delete => 'हटाएं';

  @override
  String get confirmDelete => 'क्या आप वाकई इस वारंटी को हटाना चाहते हैं?';

  @override
  String get language => 'भाषा';

  @override
  String get systemDefault => 'सिस्टम डिफॉल्ट';

  @override
  String get english => 'अंग्रेजी';

  @override
  String get hindi => 'हिंदी';

  @override
  String get marathi => 'मराठी';

  @override
  String expires(String date) {
    return 'समाप्ति: $date';
  }

  @override
  String get expiryNotSet => 'समाप्ति निर्धारित नहीं';

  @override
  String get product => 'उत्पाद';

  @override
  String get purchaseDate => 'खरीद की तारीख';

  @override
  String get warrantyDuration => 'वॉरंटी अवधि';

  @override
  String get expirationDate => 'समाप्ति तिथि';

  @override
  String months(int count) {
    return '$count महीने';
  }

  @override
  String get setExpirationDate => 'समाप्ति तिथि निर्धारित करें';

  @override
  String get durationNotFound => 'दस्तावेज़ में अवधि नहीं मिली';

  @override
  String get expirationUpdated => 'समाप्ति अद्यतन की गई!';

  @override
  String get deleteWarranty => 'वॉरंटी हटाएं?';

  @override
  String confirmRemove(String product) {
    return 'क्या आप वाकई अपने वॉल्ट से $product हटाना चाहते हैं?';
  }
}
