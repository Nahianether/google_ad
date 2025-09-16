import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../services/ad_service.dart';

class RewardedAdScreen extends StatefulWidget {
  const RewardedAdScreen({super.key});

  @override
  State<RewardedAdScreen> createState() => _RewardedAdScreenState();
}

class _RewardedAdScreenState extends State<RewardedAdScreen> {
  RewardedAd? _rewardedAd;
  bool _isRewardedAdReady = false;
  int _attempts = 0;
  int _coins = 100;
  String _lastReward = 'None';

  @override
  void initState() {
    super.initState();
    _loadRewardedAd();
  }

  void _loadRewardedAd() {
    RewardedAd.load(
      adUnitId: AdService.rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          _rewardedAd = ad;
          _isRewardedAdReady = true;
          _attempts = 0;

          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (RewardedAd ad) {
              ad.dispose();
              _loadRewardedAd();
            },
            onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
              ad.dispose();
              _loadRewardedAd();
            },
          );
          setState(() {});
        },
        onAdFailedToLoad: (LoadAdError error) {
          _attempts++;
          _rewardedAd = null;
          _isRewardedAdReady = false;
          setState(() {});
          if (_attempts < 3) {
            Future.delayed(const Duration(seconds: 1), () {
              _loadRewardedAd();
            });
          }
        },
      ),
    );
  }

  void _showRewardedAd() {
    if (_isRewardedAdReady && _rewardedAd != null) {
      _rewardedAd!.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
          setState(() {
            _coins += reward.amount.toInt();
            _lastReward = '${reward.amount} ${reward.type}';
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Reward earned: ${reward.amount} ${reward.type}'),
              backgroundColor: Colors.orange,
              duration: const Duration(seconds: 3),
            ),
          );
        },
      );
      _isRewardedAdReady = false;
      setState(() {});
    }
  }

  @override
  void dispose() {
    _rewardedAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rewarded Ad Demo'),
        backgroundColor: Colors.orange,
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange, width: 2),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.monetization_on,
                    size: 60,
                    color: Colors.orange,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '$_coins',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                  const Text(
                    'Coins',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            const Icon(
              Icons.card_giftcard,
              size: 80,
              color: Colors.orange,
            ),
            const SizedBox(height: 20),
            const Text(
              'Rewarded Ad Example',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Rewarded ads are ads that users have the option of interacting with in exchange for in-app rewards.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Last Reward:',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Text(
                    _lastReward,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _isRewardedAdReady ? Colors.orange.shade50 : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: _isRewardedAdReady ? Colors.orange : Colors.grey,
                  width: 2,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _isRewardedAdReady ? Icons.check_circle : Icons.hourglass_empty,
                    color: _isRewardedAdReady ? Colors.orange : Colors.grey,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _isRewardedAdReady ? 'Ad Ready' : 'Loading Ad...',
                    style: TextStyle(
                      color: _isRewardedAdReady ? Colors.orange : Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _isRewardedAdReady ? _showRewardedAd : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              icon: const Icon(Icons.play_arrow),
              label: const Text(
                'Watch Ad & Earn Coins',
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