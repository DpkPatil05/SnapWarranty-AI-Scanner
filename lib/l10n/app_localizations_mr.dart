// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Marathi (`mr`).
class AppLocalizationsMr extends AppLocalizations {
  AppLocalizationsMr([String locale = 'mr']) : super(locale);

  @override
  String get appTitle => 'स्नैपवॉरंटी';

  @override
  String get addDocument => 'दस्तऐवज जोडा';

  @override
  String get vaultSettings => 'वॉल्ट सेटिंग्स';

  @override
  String get cloudBackup => 'क्लाउड बॅकअप';

  @override
  String get backupDescription =>
      'तुमच्या पावत्या Google Drive वर अपलोड करा. यामुळे तुमचा फोन हरवल्यास तुमचा वॉल्ट सुरक्षित राहतो.';

  @override
  String get backupToDrive => 'ड्राइव्हवर बॅकअप घ्या';

  @override
  String get backingUp => 'बॅकअप घेतला जात आहे...';

  @override
  String get restoreVault => 'वॉल्ट पुनर्संचयित करा';

  @override
  String get restoreDescription =>
      'Google Drive वरील मागील बॅकअपमधून तुमची वॉरंटी आणि प्रतिमा पुन्हा मिळवा.';

  @override
  String get restoreFromDrive => 'ड्राइव्हवरून पुनर्संचयित करा';

  @override
  String get restoring => 'पुनर्संचयित केले जात आहे...';

  @override
  String get reminders => 'स्मरणपत्रे';

  @override
  String get remindersDescription =>
      'वॉरंटी संपण्याच्या ३० दिवस आधी आणि त्याच दिवशी सूचना मिळवा.';

  @override
  String get managePermissions => 'परवानग्या व्यवस्थापित करा';

  @override
  String get supportUs => 'आम्हाला पाठिंबा द्या';

  @override
  String get supportDescription =>
      'स्नैप वॉरंटीचा आनंद घेत आहात? इतरांना आम्हाला शोधण्यात मदत करण्यासाठी स्टोअरवर आम्हाला रेट करा!';

  @override
  String get rateAndReview => 'रेट आणि पुनरावलोकन करा';

  @override
  String version(String version) {
    return 'आवृत्ती $version';
  }

  @override
  String get search => 'वॉरंटी शोधा...';

  @override
  String get selectSource => 'स्रोत निवडा';

  @override
  String get camera => 'कॅमेरा';

  @override
  String get gallery => 'गॅलरी';

  @override
  String get pdf => 'पीडीएफ';

  @override
  String get privateSecure => 'खाजगी आणि सुरक्षित';

  @override
  String get privateSecureDesc =>
      'फक्त तुम्हीच तुमच्या ड्राइव्ह डेटावर प्रवेश करू शकता.';

  @override
  String get encryptedSync => 'एन्क्रिप्टेड सिंक';

  @override
  String get encryptedSyncDesc =>
      'मेटाडेटा OAuth2 द्वारे सुरक्षितपणे हाताळला जातो.';

  @override
  String get backupComplete => 'बॅकअप पूर्ण झाला!';

  @override
  String get restoreComplete => 'पुनर्संचयित पूर्ण झाले!';

  @override
  String error(String message) {
    return 'त्रुटी: $message';
  }

  @override
  String get noWarranties => 'कोणतेही दस्तऐवज आढळले नाहीत';

  @override
  String get scanFirst =>
      'ट्रॅकिंग सुरू करण्यासाठी तुमची पहिली पावती स्कॅन करा!';

  @override
  String get delete => 'हटवा';

  @override
  String get confirmDelete =>
      'तुमची खात्री आहे की तुम्ही ही वॉरंटी हटवू इच्छिता?';

  @override
  String get language => 'भाषा';

  @override
  String get systemDefault => 'सिस्टम डिफॉल्ट';

  @override
  String get english => 'इंग्रजी';

  @override
  String get hindi => 'हिंदी';

  @override
  String get marathi => 'मराठी';

  @override
  String expires(String date) {
    return 'समाप्ती: $date';
  }

  @override
  String get expiryNotSet => 'समाप्ती सेट नाही';

  @override
  String get product => 'उत्पादन';

  @override
  String get purchaseDate => 'खरेदीची तारीख';

  @override
  String get warrantyDuration => 'वॉरंटी कालावधी';

  @override
  String get expirationDate => 'समाप्ती तारीख';

  @override
  String months(int count) {
    return '$count महिने';
  }

  @override
  String get setExpirationDate => 'समाप्ती तारीख सेट करा';

  @override
  String get durationNotFound => 'दस्तऐवजात कालावधी आढळला नाही';

  @override
  String get expirationUpdated => 'समाप्ती अपडेट केली!';

  @override
  String get deleteWarranty => 'वॉरंटी हटवायची?';

  @override
  String confirmRemove(String product) {
    return 'तुमची खात्री आहे की तुम्ही तुमच्या वॉल्टमधून $product काढू इच्छिता?';
  }
}
