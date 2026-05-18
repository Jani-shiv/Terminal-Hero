import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdService {
  static Future<void> initialize() => MobileAds.instance.initialize();

  static const androidBannerAdUnit = 'ca-app-pub-3940256099942544/6300978111';
  static const rewardedAdUnit = 'ca-app-pub-3940256099942544/5224354917';
}
