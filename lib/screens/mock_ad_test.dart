import 'package:flutter/material.dart';

class MockAdTest extends StatelessWidget {
  const MockAdTest({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mock Ad Test'),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.check_circle,
                    size: 80,
                    color: Colors.green,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    '✅ Mock Ad Display Working!',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'This confirms the UI layout is working correctly.\nThe issue is specifically with AdMob ad loading.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.orange),
                    ),
                    child: const Column(
                      children: [
                        Text(
                          '💡 Possible Solutions:',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '• Try different network (WiFi/Mobile)\n'
                          '• Wait a few minutes and retry\n'
                          '• Test on different device\n'
                          '• Check if region supports test ads\n'
                          '• Use real ad unit IDs (production)',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Mock ad container
          Container(
            width: double.infinity,
            height: 50,
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade400, Colors.purple.shade400],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Center(
              child: Text(
                '📱 Mock Ad Banner - This is where real ads would appear',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}