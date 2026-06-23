import 'dart:io';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:in_app_review/in_app_review.dart';
import '../config/remote_config_service.dart';
import 'dart:developer' as dev;

enum AdTriggerType {
  fileAddition,
  detailView,
}

class AdService {
  AdService._internal();

  static final AdService instance = AdService._internal();

  InterstitialAd? _interstitialAd;
  bool _isInterstitialAdLoading = false;
  final InAppReview _inAppReview = InAppReview.instance;

  // Counter keys for persistence mapping
  static const Map<AdTriggerType, String> _counterKeys = {
    AdTriggerType.fileAddition: 'ad_addition_count',
    AdTriggerType.detailView: 'ad_view_count',
  };

  // Android IDs from user
  static const String _androidBannerUnitId =
      'ca-app-pub-9516145980064327/3153691224';
  static const String _androidInterstitialUnitId =
      'ca-app-pub-9516145980064327/7146686798';

  // iOS Test IDs (since real ones were not provided)
  static const String _iosBannerUnitId =
      'ca-app-pub-3940256099942544/2934735716';
  static const String _iosInterstitialUnitId =
      'ca-app-pub-3940256099942544/4411468910';

  String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return _androidBannerUnitId;
    } else if (Platform.isIOS) {
      return _iosBannerUnitId;
    }
    throw UnsupportedError('Unsupported platform');
  }

  String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return _androidInterstitialUnitId;
    } else if (Platform.isIOS) {
      return _iosInterstitialUnitId;
    }
    throw UnsupportedError('Unsupported platform');
  }

  /// Increments the file addition counter and shows an ad based on frequency.
  Future<void> incrementAdditionCounter() async {
    await _incrementAndCheckCounter(AdTriggerType.fileAddition);
  }

  /// Increments the detail view counter and shows an ad based on frequency.
  Future<void> incrementViewCounter() async {
    await _incrementAndCheckCounter(AdTriggerType.detailView);
  }

  Future<void> _incrementAndCheckCounter(AdTriggerType type) async {
    final key = _counterKeys[type]!;
    final prefs = await SharedPreferences.getInstance();
    int count = prefs.getInt(key) ?? 0;
    count++;
    await prefs.setInt(key, count);

    dev.log('${type.name} count: $count', name: 'AdService');

    // Handle In-App Review on 3rd file addition
    if (type == AdTriggerType.fileAddition && count == 3) {
      _requestReview();
    }

    final frequency = RemoteConfigService.instance.interstitialAdFrequency;

    if (count % frequency == 0) {
      dev.log(
        'Triggering Interstitial Ad for ${type.name} (Multiple of $frequency)',
        name: 'AdService',
      );
      showInterstitialAd();
    }
  }

  Future<void> _requestReview() async {
    try {
      if (await _inAppReview.isAvailable()) {
        dev.log('Requesting In-App Review...', name: 'AdService');
        await _inAppReview.requestReview();
      }
    } catch (e) {
      dev.log('In-App Review failed: $e', name: 'AdService');
    }
  }

  /// Loads an interstitial ad.
  void loadInterstitialAd() {
    if (_isInterstitialAdLoading || _interstitialAd != null) return;

    _isInterstitialAdLoading = true;
    dev.log('Loading Interstitial Ad...', name: 'AdService');

    InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          dev.log('Interstitial Ad Loaded.', name: 'AdService');
          _interstitialAd = ad;
          _isInterstitialAdLoading = false;
          _setInterstitialCallbacks(ad);
        },
        onAdFailedToLoad: (error) {
          dev.log('Interstitial Ad Failed to Load: $error', name: 'AdService');
          _interstitialAd = null;
          _isInterstitialAdLoading = false;
        },
      ),
    );
  }

  void _setInterstitialCallbacks(InterstitialAd ad) {
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        dev.log('Interstitial Ad Dismissed.', name: 'AdService');
        ad.dispose();
        _interstitialAd = null;
        loadInterstitialAd(); // Preload next
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        dev.log('Interstitial Ad Failed to Show: $error', name: 'AdService');
        ad.dispose();
        _interstitialAd = null;
        loadInterstitialAd(); // Try again
      },
    );
  }

  /// Shows the interstitial ad if loaded.
  void showInterstitialAd() {
    if (_interstitialAd != null) {
      dev.log('Showing Interstitial Ad...', name: 'AdService');
      _interstitialAd!.show();
    } else {
      dev.log('Interstitial Ad not ready yet.', name: 'AdService');
      loadInterstitialAd();
    }
  }
}
