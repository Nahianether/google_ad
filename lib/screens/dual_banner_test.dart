import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../services/ad_service.dart';

class DualBannerTest extends StatefulWidget {
  const DualBannerTest({super.key});

  @override
  State<DualBannerTest> createState() => _DualBannerTestState();
}

class _DualBannerTestState extends State<DualBannerTest> {
  BannerAd? _bannerAd1;
  BannerAd? _bannerAd2;
  bool _isBannerAd1Ready = false;
  bool _isBannerAd2Ready = false;

  @override
  void initState() {
    super.initState();
    _loadBannerAds();
  }

  void _loadBannerAds() {
    // Load first banner ad (Test_Ad)
    _bannerAd1 = BannerAd(
      adUnitId: AdService.bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          setState(() {
            _isBannerAd1Ready = true;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          ad.dispose();
          setState(() {
            _isBannerAd1Ready = false;
          });
        },
      ),
    );
    _bannerAd1!.load();

    // Load second banner ad (Test_1)
    _bannerAd2 = BannerAd(
      adUnitId: AdService.alternativeBannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          setState(() {
            _isBannerAd2Ready = true;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          ad.dispose();
          setState(() {
            _isBannerAd2Ready = false;
          });
        },
      ),
    );
    _bannerAd2!.load();
  }

  void _reloadAds() {
    _bannerAd1?.dispose();
    _bannerAd2?.dispose();
    setState(() {
      _isBannerAd1Ready = false;
      _isBannerAd2Ready = false;
    });
    _loadBannerAds();
  }

  @override
  void dispose() {
    _bannerAd1?.dispose();
    _bannerAd2?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dual Banner Test'),
        backgroundColor: Colors.indigo,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _reloadAds,
            tooltip: 'Reload Ads',
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Icon(
                    Icons.ads_click,
                    size: 60,
                    color: Colors.indigo,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Testing Both Ad Units',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'This screen tests both of your AdMob ad units to ensure they work correctly.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 32),

                  // First Ad Unit Status
                  _buildAdStatusCard(
                    'First Ad Unit (Test_Ad)',
                    'ca-app-pub-1601158099562173/8821363291',
                    _isBannerAd1Ready,
                    Colors.blue,
                  ),

                  const SizedBox(height: 16),

                  // Second Ad Unit Status
                  _buildAdStatusCard(
                    'Second Ad Unit (Test_1)',
                    'ca-app-pub-1601158099562173/2851723452',
                    _isBannerAd2Ready,
                    Colors.green,
                  ),

                  const SizedBox(height: 32),

                  // Ad performance info
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.orange),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '💡 Using Multiple Ad Units',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '• Different ad units can show different ads\n'
                          '• Helps increase fill rates and revenue\n'
                          '• Can be used for A/B testing ad performance\n'
                          '• Each unit has its own analytics in AdMob',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // First Banner Ad
          Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue),
            ),
            child: Column(
              children: [
                Text(
                  'First Ad Unit',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade700,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  width: double.infinity,
                  height: 50,
                  child: _isBannerAd1Ready && _bannerAd1 != null
                      ? AdWidget(ad: _bannerAd1!)
                      : Container(
                          color: Colors.grey.shade200,
                          child: const Center(
                            child: Text(
                              'Loading First Ad...',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),

          // Second Banner Ad
          Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.green),
            ),
            child: Column(
              children: [
                Text(
                  'Second Ad Unit',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade700,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  width: double.infinity,
                  height: 50,
                  child: _isBannerAd2Ready && _bannerAd2 != null
                      ? AdWidget(ad: _bannerAd2!)
                      : Container(
                          color: Colors.grey.shade200,
                          child: const Center(
                            child: Text(
                              'Loading Second Ad...',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdStatusCard(String title, String adUnitId, bool isReady, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isReady ? Icons.check_circle : Icons.hourglass_empty,
                color: isReady ? Colors.green : Colors.orange,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Ad Unit ID: $adUnitId',
            style: const TextStyle(
              fontSize: 12,
              fontFamily: 'monospace',
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            isReady ? 'Status: ✅ Loaded' : 'Status: ⏳ Loading...',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isReady ? Colors.green : Colors.orange,
            ),
          ),
        ],
      ),
    );
  }
}