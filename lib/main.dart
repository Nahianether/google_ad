import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'screens/banner_ad_screen.dart';
import 'screens/interstitial_ad_screen.dart';
import 'screens/rewarded_ad_screen.dart';
import 'screens/native_ad_screen.dart';
import 'screens/simple_banner_test.dart';
import 'screens/mock_ad_test.dart';
import 'screens/final_ad_test.dart';
import 'screens/production_guide.dart';
import 'screens/dual_banner_test.dart';
import 'services/ad_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: ".env");

  // Initialize AdMob
  await AdService.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Google Ads Demo',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple), useMaterial3: true),
      home: const MyHomePage(title: 'Google Ads Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<AdDemoItem> _adTypes = [
    AdDemoItem(
      title: 'Dual Banner Test',
      subtitle: 'Test both your real AdMob ad units',
      icon: Icons.double_arrow,
      color: Colors.indigo,
      route: '/dual_banner',
    ),
    AdDemoItem(
      title: 'Production Guide',
      subtitle: 'How to use real ads in your app',
      icon: Icons.publish,
      color: Colors.purple,
      route: '/production',
    ),
    AdDemoItem(
      title: 'Final Ad Test',
      subtitle: 'Complete ad test with connectivity check',
      icon: Icons.rocket_launch,
      color: Colors.teal,
      route: '/final',
    ),
    AdDemoItem(
      title: 'Mock Ad Test',
      subtitle: 'Verify UI layout works (no real ads)',
      icon: Icons.preview,
      color: Colors.green,
      route: '/mock',
    ),
    AdDemoItem(
      title: 'Simple Banner Test',
      subtitle: 'Basic banner ad test to debug issues',
      icon: Icons.bug_report,
      color: Colors.red,
      route: '/simple_banner',
    ),
    AdDemoItem(
      title: 'Banner Ads',
      subtitle: 'Rectangular ads at top/bottom of screen',
      icon: Icons.ad_units,
      color: Colors.blue,
      route: '/banner',
    ),
    AdDemoItem(
      title: 'Interstitial Ads',
      subtitle: 'Full-screen ads at natural app transitions',
      icon: Icons.fullscreen,
      color: Colors.green,
      route: '/interstitial',
    ),
    AdDemoItem(
      title: 'Rewarded Ads',
      subtitle: 'Ads that reward users for viewing',
      icon: Icons.card_giftcard,
      color: Colors.orange,
      route: '/rewarded',
    ),
    AdDemoItem(
      title: 'Native Ads',
      subtitle: 'Ads that match your app\'s design',
      icon: Icons.integration_instructions,
      color: Colors.purple,
      route: '/native',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Icon(Icons.ads_click, size: 80, color: Theme.of(context).primaryColor),
                const SizedBox(height: 16),
                const Text('Google Ads Demo', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(
                  'Explore different types of Google AdMob advertisements',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _adTypes.length,
              itemBuilder: (context, index) {
                final adType = _adTypes[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: adType.color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(adType.icon, color: adType.color, size: 24),
                    ),
                    title: Text(adType.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    subtitle: Text(adType.subtitle, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      _navigateToAdScreen(adType.route);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToAdScreen(String route) {
    Widget screen;
    switch (route) {
      case '/dual_banner':
        screen = const DualBannerTest();
        break;
      case '/production':
        screen = const ProductionGuide();
        break;
      case '/final':
        screen = const FinalAdTest();
        break;
      case '/mock':
        screen = const MockAdTest();
        break;
      case '/simple_banner':
        screen = const SimpleBannerTest();
        break;
      case '/banner':
        screen = const BannerAdScreen();
        break;
      case '/interstitial':
        screen = const InterstitialAdScreen();
        break;
      case '/rewarded':
        screen = const RewardedAdScreen();
        break;
      case '/native':
        screen = const NativeAdScreen();
        break;
      default:
        return;
    }

    Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
  }
}

class AdDemoItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final String route;

  AdDemoItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.route,
  });
}
