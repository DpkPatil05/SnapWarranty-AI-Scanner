import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../widgets/glass/glass_container.dart';
import '../../widgets/glass/liquid_glass_background.dart';
import '../home/home_page.dart';

class WalkthroughPage extends StatefulWidget {
  const WalkthroughPage({super.key});

  @override
  State<WalkthroughPage> createState() => _WalkthroughPageState();
}

class _WalkthroughPageState extends State<WalkthroughPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<WalkthroughSlide> _slides = [
    WalkthroughSlide(
      title: 'AI Smart Scanner',
      description:
          'Snap a photo of any receipt or PDF. Our Gemini AI instantly extracts product names, dates, and warranty info.',
      icon: Icons.auto_awesome,
      color: Colors.blueAccent,
    ),
    WalkthroughSlide(
      title: 'Never Miss Expiry',
      description:
          'Get automated notifications 30 days before and on the day your warranty ends. Keep your items protected.',
      icon: Icons.notifications_active,
      color: Colors.indigoAccent,
    ),
    WalkthroughSlide(
      title: 'Cloud Secure Sync',
      description:
          'Your vault is automatically backed up to your personal Google Drive. Your data stays yours, forever.',
      icon: Icons.cloud_done,
      color: Colors.purpleAccent,
    ),
  ];

  Future<void> _completeWalkthrough() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_seen_walkthrough', true);
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const LiquidGlassBackground(),

          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemCount: _slides.length,
            itemBuilder: (context, index) {
              final slide = _slides[index];
              return Padding(
                padding: const EdgeInsets.all(40.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Animated Icon Container
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.0, end: 1.0),
                      duration: const Duration(milliseconds: 600),
                      builder: (context, value, child) {
                        return Transform.scale(
                          scale: value,
                          child: GlassContainer(
                            padding: const EdgeInsets.all(32),
                            borderRadius: 100,
                            child: Icon(
                              slide.icon,
                              size: 80,
                              color: slide.color,
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 60),
                    Text(
                      slide.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -1,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      slide.description,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 16,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          // Bottom Navigation
          Positioned(
            bottom: 60,
            left: 40,
            right: 40,
            child: Column(
              children: [
                // Page Indicators
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_slides.length, (index) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      height: 8,
                      width: _currentPage == index ? 24 : 8,
                      decoration: BoxDecoration(
                        color: _currentPage == index
                            ? Colors.white
                            : Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 40),

                // Action Button
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_currentPage < _slides.length - 1) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        _completeWalkthrough();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF1E1B4B),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      _currentPage == _slides.length - 1
                          ? 'Get Started'
                          : 'Next',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),

                // Skip Button
                if (_currentPage < _slides.length - 1)
                  TextButton(
                    onPressed: _completeWalkthrough,
                    child: Text(
                      'Skip',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.5),
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
}

class WalkthroughSlide {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  WalkthroughSlide({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}
