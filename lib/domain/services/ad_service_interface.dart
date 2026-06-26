import 'package:google_mobile_ads/google_mobile_ads.dart';

abstract class IAdService {
  void init();

  void loadInterstitialAd();

  void showInterstitialAd();

  Future<void> incrementAdditionCounter();

  Future<void> incrementViewCounter();

  BannerAd createBannerAd({
    required void Function(Ad) onAdLoaded,
    required void Function(Ad, LoadAdError) onAdFailedToLoad,
    String? logLabel,
  });

  String get bannerAdUnitId;

  String get interstitialAdUnitId;
}
