import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class NativeAdScreen extends StatefulWidget {
  const NativeAdScreen({super.key});

  @override
  State<NativeAdScreen> createState() => _NativeAdScreenState();
}

class _NativeAdScreenState extends State<NativeAdScreen> {
  NativeAd? _nativeAd;
  bool _isNativeAdReady = false;

  @override
  void initState() {
    super.initState();
    _loadNativeAd();
  }

  void _loadNativeAd() {
    // Temporarily disabled native ads due to factory registration issue
    // _nativeAd = NativeAd(
    //   adUnitId: AdService.nativeAdUnitId,
    //   factoryId: 'listTile',
    //   request: const AdRequest(),
    //   listener: NativeAdListener(
    //     onAdLoaded: (Ad ad) {
    //       setState(() {
    //         _isNativeAdReady = true;
    //       });
    //     },
    //     onAdFailedToLoad: (Ad ad, LoadAdError error) {
    //       ad.dispose();
    //       setState(() {
    //         _isNativeAdReady = false;
    //       });
    //     },
    //   ),
    // );
    // _nativeAd!.load();
    debugPrint('Native ads temporarily disabled - factory registration needs fixing');
  }

  @override
  void dispose() {
    _nativeAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Native Ad Demo'),
        backgroundColor: Colors.purple,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              child: const Column(
                children: [
                  Icon(
                    Icons.integration_instructions,
                    size: 80,
                    color: Colors.purple,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Native Ad Example',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Native ads are ad assets that are presented to users via UI components that are native to the platform. They blend seamlessly with the app content.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),

            if (_isNativeAdReady && _nativeAd != null)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                height: 150,
                child: AdWidget(ad: _nativeAd!),
              )
            else
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(color: Colors.purple),
                      SizedBox(height: 10),
                      Text(
                        'Loading Native Ad...',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 30),

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.purple.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.purple.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.purple.shade700, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'About Native Ads',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple.shade700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    '• Native ads match the look and feel of your app content\n'
                    '• They provide better user experience compared to banner ads\n'
                    '• Users can interact with them naturally\n'
                    '• They typically have higher engagement rates\n'
                    '• Require custom native ad templates for different platforms',
                    style: TextStyle(fontSize: 14, height: 1.5),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 5,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.purple.shade100,
                      child: Icon(Icons.article, color: Colors.purple),
                    ),
                    title: Text('Sample Content ${index + 1}'),
                    subtitle: const Text('This is sample content to demonstrate how native ads blend with regular content.'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  ),
                );
              },
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}