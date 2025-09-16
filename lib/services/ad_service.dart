import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdService {
  // Check if we're in development mode
  static bool get _isDevelopment {
    return dotenv.env['IS_DEVELOPMENT']?.toLowerCase() == 'true';
  }

  // Test ad unit IDs for development
  static const String _testBannerAndroid = 'ca-app-pub-3940256099942544/6300978111';
  static const String _testBannerIOS = 'ca-app-pub-3940256099942544/2934735716';
  static const String _testInterstitialAndroid = 'ca-app-pub-3940256099942544/1033173712';
  static const String _testInterstitialIOS = 'ca-app-pub-3940256099942544/4411468910';
  static const String _testRewardedAndroid = 'ca-app-pub-3940256099942544/5224354917';
  static const String _testRewardedIOS = 'ca-app-pub-3940256099942544/1712485313';
  static const String _testNativeAndroid = 'ca-app-pub-3940256099942544/2247696110';
  static const String _testNativeIOS = 'ca-app-pub-3940256099942544/3986624511';

  static String get bannerAdUnitId {
    if (_isDevelopment) {
      return Platform.isAndroid ? _testBannerAndroid : _testBannerIOS;
    }

    if (Platform.isAndroid) {
      return dotenv.env['ADMOB_BANNER_AD_UNIT_ID_ANDROID'] ?? _testBannerAndroid;
    } else if (Platform.isIOS) {
      return dotenv.env['ADMOB_BANNER_AD_UNIT_ID_IOS'] ?? _testBannerIOS;
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get interstitialAdUnitId {
    if (_isDevelopment) {
      return Platform.isAndroid ? _testInterstitialAndroid : _testInterstitialIOS;
    }

    if (Platform.isAndroid) {
      return dotenv.env['ADMOB_INTERSTITIAL_AD_UNIT_ID_ANDROID'] ?? _testInterstitialAndroid;
    } else if (Platform.isIOS) {
      return dotenv.env['ADMOB_INTERSTITIAL_AD_UNIT_ID_IOS'] ?? _testInterstitialIOS;
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get rewardedAdUnitId {
    if (_isDevelopment) {
      return Platform.isAndroid ? _testRewardedAndroid : _testRewardedIOS;
    }

    if (Platform.isAndroid) {
      return dotenv.env['ADMOB_REWARDED_AD_UNIT_ID_ANDROID'] ?? _testRewardedAndroid;
    } else if (Platform.isIOS) {
      return dotenv.env['ADMOB_REWARDED_AD_UNIT_ID_IOS'] ?? _testRewardedIOS;
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get nativeAdUnitId {
    if (_isDevelopment) {
      return Platform.isAndroid ? _testNativeAndroid : _testNativeIOS;
    }

    if (Platform.isAndroid) {
      return dotenv.env['ADMOB_NATIVE_AD_UNIT_ID_ANDROID'] ?? _testNativeAndroid;
    } else if (Platform.isIOS) {
      return dotenv.env['ADMOB_NATIVE_AD_UNIT_ID_IOS'] ?? _testNativeIOS;
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get appId {
    if (Platform.isAndroid) {
      return dotenv.env['ADMOB_APP_ID_ANDROID'] ?? 'ca-app-pub-3940256099942544~3347511713';
    } else if (Platform.isIOS) {
      return dotenv.env['ADMOB_APP_ID_IOS'] ?? 'ca-app-pub-3940256099942544~1458002511';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  // Alternative banner ad unit ID (Test_1)
  static String get alternativeBannerAdUnitId {
    if (_isDevelopment) {
      return Platform.isAndroid ? _testBannerAndroid : _testBannerIOS;
    }

    if (Platform.isAndroid) {
      return dotenv.env['ADMOB_BANNER_AD_UNIT_ID_ANDROID_ALT'] ?? _testBannerAndroid;
    } else if (Platform.isIOS) {
      return dotenv.env['ADMOB_BANNER_AD_UNIT_ID_IOS_ALT'] ?? _testBannerIOS;
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static Future<void> initialize() async {
    debugPrint('🚀 Initializing Google Mobile Ads...');
    debugPrint('📱 App ID: ${appId}');
    debugPrint('🔧 Development mode: $_isDevelopment');

    final initResult = await MobileAds.instance.initialize();
    debugPrint('✅ Google Mobile Ads initialized successfully');
    debugPrint('Adapter status: ${initResult.adapterStatuses}');

    // Simplified configuration - sometimes test device ID can block ads
    await MobileAds.instance.updateRequestConfiguration(
      RequestConfiguration(
        tagForChildDirectedTreatment: TagForChildDirectedTreatment.unspecified,
        maxAdContentRating: MaxAdContentRating.g,
      ),
    );
    debugPrint('🧪 Basic ad configuration applied');
  }

  static BannerAd createBannerAd({bool useAlternative = false}) {
    String adUnitId = useAlternative ? alternativeBannerAdUnitId : bannerAdUnitId;
    String adType = useAlternative ? 'Alternative BannerAd' : 'BannerAd';

    debugPrint('🔄 Creating $adType with ID: $adUnitId');

    return BannerAd(
      adUnitId: adUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          debugPrint('✅ $adType loaded successfully');
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          debugPrint('❌ $adType failed to load: ${error.message}');
          debugPrint('Error code: ${error.code}');
          debugPrint('Error domain: ${error.domain}');
          ad.dispose();
        },
        onAdOpened: (Ad ad) => debugPrint('$adType opened'),
        onAdClosed: (Ad ad) => debugPrint('$adType closed'),
      ),
    );
  }

  static void createInterstitialAd(Function(InterstitialAd) onAdLoaded) {
    InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          debugPrint('✅ InterstitialAd loaded successfully');
          onAdLoaded(ad);
        },
        onAdFailedToLoad: (LoadAdError error) {
          debugPrint('❌ InterstitialAd failed to load: ${error.message}');
        },
      ),
    );
  }

  static void createRewardedAd(Function(RewardedAd) onAdLoaded) {
    RewardedAd.load(
      adUnitId: rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          debugPrint('✅ RewardedAd loaded successfully');
          onAdLoaded(ad);
        },
        onAdFailedToLoad: (LoadAdError error) {
          debugPrint('❌ RewardedAd failed to load: ${error.message}');
        },
      ),
    );
  }

  static NativeAd createNativeAd() {
    return NativeAd(
      adUnitId: nativeAdUnitId,
      factoryId: 'listTile',
      request: const AdRequest(),
      listener: NativeAdListener(
        onAdLoaded: (Ad ad) => debugPrint('✅ NativeAd loaded successfully'),
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          debugPrint('❌ NativeAd failed to load: ${error.message}');
          ad.dispose();
        },
      ),
    );
  }
}