import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:io';
import 'dart:async';

class FinalAdTest extends StatefulWidget {
  const FinalAdTest({super.key});

  @override
  State<FinalAdTest> createState() => _FinalAdTestState();
}

class _FinalAdTestState extends State<FinalAdTest> {
  BannerAd? _bannerAd;
  bool _isBannerAdReady = false;
  bool _isLoading = false;
  String _statusMessage = 'Ready to test';
  int _attemptCount = 0;

  @override
  void initState() {
    super.initState();
  }

  Future<bool> _checkConnectivity() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  void _loadBannerAd() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      _attemptCount++;
      _statusMessage = 'Attempt $_attemptCount: Checking connectivity...';
    });

    // Check internet connectivity
    bool isConnected = await _checkConnectivity();
    if (!isConnected) {
      setState(() {
        _isLoading = false;
        _statusMessage = '❌ No internet connection';
      });
      return;
    }

    setState(() {
      _statusMessage = 'Attempt $_attemptCount: Internet OK, loading ad...';
    });

    _bannerAd?.dispose();

    // Try different ad unit IDs based on attempt count
    String adUnitId;
    if (Platform.isAndroid) {
      switch (_attemptCount % 3) {
        case 0:
          adUnitId = 'ca-app-pub-3940256099942544/6300978111'; // Banner
          break;
        case 1:
          adUnitId = 'ca-app-pub-3940256099942544/9214589741'; // Alternative banner
          break;
        default:
          adUnitId = 'ca-app-pub-3940256099942544/2247696110'; // Native as banner
      }
    } else {
      adUnitId = 'ca-app-pub-3940256099942544/2934735716';
    }

    debugPrint('🔄 Attempt $_attemptCount: Loading banner ad with ID: $adUnitId');

    _bannerAd = BannerAd(
      adUnitId: adUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          debugPrint('✅ Banner Ad loaded successfully on attempt $_attemptCount');
          if (mounted) {
            setState(() {
              _isBannerAdReady = true;
              _isLoading = false;
              _statusMessage = '✅ Ad loaded successfully!';
            });
          }
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          debugPrint('❌ Banner Ad failed on attempt $_attemptCount: ${error.message}');
          ad.dispose();
          if (mounted) {
            setState(() {
              _isBannerAdReady = false;
              _isLoading = false;
              _statusMessage = '❌ Attempt $_attemptCount failed: ${error.message}';
            });
          }
        },
        onAdOpened: (Ad ad) => debugPrint('Banner ad opened'),
        onAdClosed: (Ad ad) => debugPrint('Banner ad closed'),
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
        title: const Text('Final Ad Test'),
        backgroundColor: Colors.teal,
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _isBannerAdReady
                        ? Icons.check_circle
                        : _isLoading
                            ? Icons.hourglass_empty
                            : Icons.ads_click,
                    size: 80,
                    color: _isBannerAdReady
                        ? Colors.green
                        : _isLoading
                            ? Colors.orange
                            : Colors.teal,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    _isBannerAdReady
                        ? 'Ad Loaded Successfully!'
                        : 'Final AdMob Test',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _statusMessage,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: _isBannerAdReady
                          ? Colors.green
                          : Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 30),
                  if (!_isBannerAdReady && !_isLoading) ...[
                    ElevatedButton.icon(
                      onPressed: _loadBannerAd,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                      icon: const Icon(Icons.refresh),
                      label: Text(
                        _attemptCount == 0 ? 'Test Ad Loading' : 'Try Again ($_attemptCount attempts)',
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '📋 This test will:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            '• Check internet connectivity\n'
                            '• Try different ad unit IDs\n'
                            '• Show detailed error messages\n'
                            '• Test multiple times if needed',
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ],
                  if (_isLoading) ...[
                    const CircularProgressIndicator(),
                    const SizedBox(height: 16),
                    const Text('Loading...'),
                  ],
                ],
              ),
            ),
          ),
          // Ad container
          Container(
            width: double.infinity,
            height: 60,
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _isBannerAdReady ? Colors.white : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: _isBannerAdReady ? Colors.teal : Colors.grey.shade300,
                width: 2,
              ),
            ),
            child: _isBannerAdReady && _bannerAd != null
                ? Center(child: AdWidget(ad: _bannerAd!))
                : Center(
                    child: Text(
                      _isLoading
                          ? '⏳ Loading ad...'
                          : '📱 Ad will appear here',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}