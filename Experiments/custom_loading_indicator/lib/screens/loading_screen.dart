import 'package:flutter/material.dart';
import '../widgets/spinning_loader.dart';
import '../widgets/bouncing_dots.dart';

class LoadingScreen extends StatefulWidget 
{
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> 
{
  bool isLoading = false;

  Future<void> startLoading() async 
  {
    setState(() => isLoading = true);
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) 
  {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Loading Indicator'),
        centerTitle: true,
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: 
          [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: isLoading
                  ? Column(
                      key: const ValueKey('loading'),
                      children: const [
                        SpinningLoader(size: 70),
                        SizedBox(height: 40),
                        BouncingDots(),
                        SizedBox(height: 24),
                        Text(
                          'Loading...',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      ],
                    )
                  : Column(
                      key: const ValueKey('done'),
                      children: const [
                        Icon(Icons.check_circle, size: 80, color: Colors.green),
                        SizedBox(height: 16),
                        Text(
                          'Press the button to load',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      ],
                    ),
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: isLoading ? null : startLoading,
              child: const Text('Start Loading'),
            ),
          ],
        ),
      ),
    );
  }
}
