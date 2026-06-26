abstract class IAdService {
  void init();

  void loadInterstitialAd();

  void showInterstitialAd();

  Future<void> incrementAdditionCounter();

  Future<void> incrementViewCounter();

  String get bannerAdUnitId;

  String get interstitialAdUnitId;
}
