import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class BasicAdTest extends StatefulWidget {
  const BasicAdTest({super.key});

  @override
  State<BasicAdTest> createState() => _BasicAdTestState();
}

class _BasicAdTestState extends State<BasicAdTest> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;
  String _statusMessage = 'Initializing...';

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  void _loadAd() {
    setState(() {
      _statusMessage = 'Loading test ad...';
    });

    // Use Google's guaranteed test ad unit for Android
    _bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-3940256099942544/6300978111', // Google test banner
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          debugPrint('✅ Test ad loaded successfully!');
          setState(() {
            _isLoaded = true;
            _statusMessage = 'Test ad loaded successfully! ✅';
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          debugPrint('❌ Test ad failed to load: ${error.message}');
          debugPrint('Error code: ${error.code}');
          debugPrint('Error domain: ${error.domain}');
          setState(() {
            _statusMessage = 'Failed to load: ${error.message} (Code: ${error.code})';
          });
          ad.dispose();
        },
        onAdOpened: (Ad ad) => debugPrint('Test ad opened'),
        onAdClosed: (Ad ad) => debugPrint('Test ad closed'),
      ),
    );

    _bannerAd?.load();
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
        title: const Text('Basic Test Ad'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Google Test Ad',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text('Using Google\'s guaranteed test ad unit:'),
                    const SizedBox(height: 4),
                    const Text(
                      'ca-app-pub-3940256099942544/6300978111',
                      style: TextStyle(fontFamily: 'monospace', fontSize: 12),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(
                          _isLoaded ? Icons.check_circle : Icons.pending,
                          color: _isLoaded ? Colors.green : Colors.orange,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _statusMessage,
                            style: TextStyle(
                              color: _isLoaded ? Colors.green : Colors.black87,
                              fontWeight: _isLoaded ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (_isLoaded && _bannerAd != null)
              Card(
                elevation: 4,
                child: Container(
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.green, width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: AdWidget(ad: _bannerAd!),
                ),
              ),
            const SizedBox(height: 20),
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Test Instructions:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text('1. This uses Google\'s guaranteed test ad unit'),
                    Text('2. Test ads should always load successfully'),
                    Text('3. If this fails, there\'s a configuration issue'),
                    Text('4. Check the console logs for detailed error messages'),
                  ],
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _bannerAd?.dispose();
                  _bannerAd = null;
                  setState(() {
                    _isLoaded = false;
                  });
                  _loadAd();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Reload Test Ad'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}