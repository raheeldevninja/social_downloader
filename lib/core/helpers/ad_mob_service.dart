import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdMobService {

  static String get bannerAdUnitId {

    //test Ad Unit ID
    //return 'ca-app-pub-3940256099942544/6300978111';

    //SaveInsta app Ad Unit ID
    return 'ca-app-pub-5509377841556322/3657507855';
  }

  static final BannerAdListener bannerAdListener = BannerAdListener(
    onAdLoaded: (Ad ad) {
      print('Ad loaded: $ad');
    },
    onAdFailedToLoad: (Ad ad, LoadAdError error) {
      ad.dispose();
      print('Ad failed to load: $error');
    },
    onAdOpened: (Ad ad) {
      print('Ad opened: $ad');
    },
    onAdClosed: (Ad ad) {
      print('Ad closed: $ad');
    },
  );

}