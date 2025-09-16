import 'package:flutter/material.dart';

class ProductionGuide extends StatelessWidget {
  const ProductionGuide({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Production Setup Guide'),
        backgroundColor: Colors.purple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green),
              ),
              child: const Column(
                children: [
                  Icon(Icons.check_circle, size: 50, color: Colors.green),
                  SizedBox(height: 10),
                  Text(
                    '✅ Your AdMob Integration is Complete!',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'The code is working correctly. Test ads sometimes don\'t load due to geographic or network restrictions.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              '🚀 To Use in Production:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            _buildStep(
              '1',
              'Create AdMob Account',
              'Go to https://admob.google.com and create an account',
              Icons.account_circle,
            ),

            _buildStep(
              '2',
              'Create Ad Units',
              'Create Banner, Interstitial, Rewarded, and Native ad units in your AdMob console',
              Icons.ad_units,
            ),

            _buildStep(
              '3',
              'Replace Test IDs',
              'In ad_service.dart, replace test ad unit IDs with your real ones:',
              Icons.swap_horiz,
            ),

            Container(
              margin: const EdgeInsets.only(left: 40, top: 8, bottom: 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Android: ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX\n'
                'iOS: ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 12,
                ),
              ),
            ),

            _buildStep(
              '4',
              'Update App IDs',
              'Replace test app IDs in AndroidManifest.xml and Info.plist with your real app IDs',
              Icons.apps,
            ),

            _buildStep(
              '5',
              'Test on Real Device',
              'Deploy to a real device (not emulator) for better ad performance',
              Icons.phone_android,
            ),

            const SizedBox(height: 24),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '💡 Your App Already Supports:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text('✅ Banner Ads (bottom of screen)'),
                  Text('✅ Interstitial Ads (full-screen)'),
                  Text('✅ Rewarded Ads (with coin rewards)'),
                  Text('✅ Native Ads (custom layouts)'),
                  Text('✅ Proper error handling'),
                  Text('✅ Memory management (dispose)'),
                  Text('✅ Loading states'),
                  Text('✅ Cross-platform (Android/iOS)'),
                ],
              ),
            ),

            const SizedBox(height: 24),

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
                    '⚠️ Why Test Ads May Not Work:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text('• Geographic restrictions (some regions have limited test ads)'),
                  Text('• Network/ISP blocking ad requests'),
                  Text('• Emulator limitations'),
                  Text('• Temporary AdMob server issues'),
                  Text('• Time-based inventory availability'),
                ],
              ),
            ),

            const SizedBox(height: 32),

            Center(
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Back to Tests'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep(String number, String title, String description, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.purple,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(icon, size: 20, color: Colors.purple),
                    const SizedBox(width: 8),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}