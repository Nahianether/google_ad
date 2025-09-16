import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:io';

class SimpleBannerTest extends StatefulWidget {
  const SimpleBannerTest({super.key});

  @override
  State<SimpleBannerTest> createState() => _SimpleBannerTestState();
}

class _SimpleBannerTestState extends State<SimpleBannerTest> {
  BannerAd? _bannerAd;
  bool _isBannerAdReady = false;

  @override
  void initState() {
    super.initState();
    _loadBannerAd();
  }

  void _loadBannerAd() {
    // Using the original test banner ad unit ID which is more reliable
    String adUnitId;
    if (Platform.isAndroid) {
      adUnitId = 'ca-app-pub-3940256099942544/6300978111'; // Original Android banner test ID
    } else {
      adUnitId = 'ca-app-pub-3940256099942544/2934735716'; // Original iOS banner test ID
    }

    debugPrint('🔄 Loading banner ad with ID: $adUnitId');

    _bannerAd = BannerAd(
      adUnitId: adUnitId,
      size: AdSize.banner,
      request: const AdRequest(), // Simplified - no extra parameters
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          debugPrint('✅ Simple Banner Ad loaded successfully');
          setState(() {
            _isBannerAdReady = true;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          debugPrint('❌ Simple Banner Ad failed to load: ${error.message}');
          debugPrint('Error code: ${error.code}');
          debugPrint('Error domain: ${error.domain}');
          debugPrint('Response info: ${error.responseInfo}');
          ad.dispose();
          setState(() {
            _isBannerAdReady = false;
          });

          // Try again after a delay
          Future.delayed(const Duration(seconds: 3), () {
            if (mounted) {
              debugPrint('🔄 Retrying banner ad load...');
              _loadBannerAd();
            }
          });
        },
        onAdOpened: (Ad ad) => debugPrint('Banner ad opened'),
        onAdClosed: (Ad ad) => debugPrint('Banner ad closed'),
        onAdImpression: (Ad ad) => debugPrint('Banner ad impression'),
      ),
    );
    _bannerAd!.load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simple Banner Test'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _isBannerAdReady ? '✅ Banner Ad Loaded!' : '⏳ Loading Banner Ad...',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'This is a simplified banner ad test.\nIf this works, the issue was with the complex setup.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      _bannerAd?.dispose();
                      setState(() {
                        _isBannerAdReady = false;
                      });
                      _loadBannerAd();
                    },
                    child: const Text('Reload Ad'),
                  ),
                ],
              ),
            ),
          ),
          if (_isBannerAdReady && _bannerAd != null)
            Container(
              alignment: Alignment.center,
              width: _bannerAd!.size.width.toDouble(),
              height: _bannerAd!.size.height.toDouble(),
              child: AdWidget(ad: _bannerAd!),
            )
          else
            Container(
              alignment: Alignment.center,
              width: 320,
              height: 50,
              color: Colors.grey.shade200,
              child: const Text(
                'Ad Loading...',
                style: TextStyle(color: Colors.grey),
              ),
            ),
        ],
      ),
    );
  }
}