import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../services/prefs_service.dart';
import '../utils/app_routes.dart';
import '../widgets/responsive_center.dart';

class _OnboardingData {
  final IconData icon;
  final String title;
  final String text;

  const _OnboardingData(this.icon, this.title, this.text);
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _page = 0;

  static const List<_OnboardingData> _pages = [
    _OnboardingData(
      Icons.event,
      'Discover campus events',
      'Browse upcoming events, search them and never miss what is happening.',
    ),
    _OnboardingData(
      Icons.edit_note,
      'Keep personal notes',
      'Write quick notes for lectures and events, saved right on your device.',
    ),
    _OnboardingData(
      Icons.how_to_reg,
      'RSVP and stay in sync',
      'Reserve your spot and keep everything synced with the cloud.',
    ),
  ];

  bool get _isLast => _page == _pages.length - 1;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Remember that onboarding was seen, then continue
  Future<void> _finish() async {
    await PrefsService().setOnboardingSeen();
    if (!mounted) return;

    final loggedIn = context.read<AuthProvider>().isLoggedIn;
    Navigator.pushReplacementNamed(
      context,
      loggedIn ? AppRoutes.home : AppRoutes.login,
    );
  }

  void _next() {
    if (_isLast) {
      _finish();
    } else {
      _controller.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 48,
              child: Align(
                alignment: Alignment.centerRight,
                child: _isLast
                    ? null
                    : TextButton(onPressed: _finish, child: const Text('Skip')),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _pages.length,
                onPageChanged: (index) => setState(() => _page = index),
                itemBuilder: (context, index) {
                  final data = _pages[index];
                  return ResponsiveCenter(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(data.icon, size: 120, color: color),
                          const SizedBox(height: 32),
                          Text(
                            data.title,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            data.text,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            // Dots: the active one stretches (animation)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_pages.length, (i) {
                final active = _page == i;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  height: 8,
                  width: active ? 24 : 8,
                  decoration: BoxDecoration(
                    color: active ? color : Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: FilledButton(
                  onPressed: _next,
                  child: Text(_isLast ? 'Get started' : 'Next'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
