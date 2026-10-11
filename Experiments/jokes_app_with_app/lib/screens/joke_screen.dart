import 'package:flutter/material.dart';
import '../models/joke.dart';
import '../services/joke_service.dart';

class JokeScreen extends StatefulWidget {
  const JokeScreen({super.key});

  @override
  State<JokeScreen> createState() => _JokeScreenState();
}

class _JokeScreenState extends State<JokeScreen> {
  // the Future that FutureBuilder is waiting on
  late Future<Joke?> jokeFuture;

  @override
  void initState() {
    super.initState();
    jokeFuture = JokeService.fetchJoke();
  }

  // start a new request; setState makes FutureBuilder rebuild
  void loadNewJoke() {
    setState(() {
      jokeFuture = JokeService.fetchJoke();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Joke App')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder<Joke?>(
                future: jokeFuture,
                builder: (context, snapshot) {
                  // 1. LOADING
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  // 2. ERROR
                  if (snapshot.hasError) {
                    return messageView(
                      icon: Icons.error_outline,
                      color: Colors.red,
                      text: snapshot.error.toString(),
                    );
                  }

                  // 3. EMPTY
                  final joke = snapshot.data;
                  if (joke == null) {
                    return messageView(
                      icon: Icons.inbox,
                      color: Colors.grey,
                      text: 'No joke was returned. Try again.',
                    );
                  }

                  // 4. SUCCESS
                  return Center(
                    child: SingleChildScrollView(
                      child: Card(
                        elevation: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.emoji_emotions, size: 40),
                              const SizedBox(height: 8),
                              if (joke.category.isNotEmpty)
                                Chip(label: Text(joke.category)),
                              const SizedBox(height: 12),
                              Text(
                                joke.setup,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                joke.punchline,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.refresh),
                label: const Text('New Joke'),
                onPressed: loadNewJoke,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // icon + text, used for the error and empty states
  Widget messageView({
    required IconData icon,
    required Color color,
    required String text,
  }) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 60, color: color),
          const SizedBox(height: 12),
          Text(text, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
