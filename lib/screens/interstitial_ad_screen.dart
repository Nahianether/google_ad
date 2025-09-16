import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../services/ad_service.dart';

class InterstitialAdScreen extends StatefulWidget {
  const InterstitialAdScreen({super.key});

  @override
  State<InterstitialAdScreen> createState() => _InterstitialAdScreenState();
}

class _InterstitialAdScreenState extends State<InterstitialAdScreen> {
  InterstitialAd? _interstitialAd;
  bool _isInterstitialAdReady = false;
  int _attempts = 0;

  @override
  void initState() {
    super.initState();
    _loadInterstitialAd();
  }

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdService.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          _isInterstitialAdReady = true;
          _attempts = 0;

          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (InterstitialAd ad) {
              ad.dispose();
              _loadInterstitialAd();
            },
            onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
              ad.dispose();
              _loadInterstitialAd();
            },
          );
          setState(() {});
        },
        onAdFailedToLoad: (LoadAdError error) {
          _attempts++;
          _interstitialAd = null;
          _isInterstitialAdReady = false;
          setState(() {});
          if (_attempts < 3) {
            Future.delayed(const Duration(seconds: 1), () {
              _loadInterstitialAd();
            });
          }
        },
      ),
    );
  }

  void _showInterstitialAd() {
    if (_isInterstitialAdReady && _interstitialAd != null) {
      _interstitialAd!.show();
      _isInterstitialAdReady = false;
      setState(() {});
    }
  }

  @override
  void dispose() {
    _interstitialAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Interstitial Ad Demo'),
        backgroundColor: Colors.green,
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.fullscreen,
              size: 80,
              color: Colors.green,
            ),
            const SizedBox(height: 20),
            const Text(
              'Interstitial Ad Example',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Interstitial ads are full-screen ads that cover the interface of their host app. They are typically displayed at natural transition points in the flow of an app.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _isInterstitialAdReady ? Colors.green.shade50 : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: _isInterstitialAdReady ? Colors.green : Colors.grey,
                  width: 2,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _isInterstitialAdReady ? Icons.check_circle : Icons.hourglass_empty,
                    color: _isInterstitialAdReady ? Colors.green : Colors.grey,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _isInterstitialAdReady ? 'Ad Ready' : 'Loading Ad...',
                    style: TextStyle(
                      color: _isInterstitialAdReady ? Colors.green : Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isInterstitialAdReady ? _showInterstitialAd : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Show Interstitial Ad',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            if (_attempts >= 3)
              Container(
                margin: const EdgeInsets.only(top: 20),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red, width: 1),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.error, color: Colors.red, size: 20),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Failed to load ad after 3 attempts. Please check your internet connection.',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}