import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import '../models/quote.dart';
import '../services/quote_service.dart';
import '../utils/quote_formatter.dart';

class QuoteScreen extends StatefulWidget {
  const QuoteScreen({super.key});

  @override
  State<QuoteScreen> createState() => _QuoteScreenState();
}

class _QuoteScreenState extends State<QuoteScreen> {
  // the Future that FutureBuilder is waiting on
  late Future<Quote?> quoteFuture;

  @override
  void initState() {
    super.initState();
    quoteFuture = QuoteService.fetchQuote();
  }

  // start a new request; setState makes FutureBuilder rebuild
  void loadNewQuote() {
    setState(() {
      quoteFuture = QuoteService.fetchQuote();
    });
  }

  // COPY: put the formatted message on the clipboard
  Future<void> copyQuote(Quote quote) async {
    final message = formatQuoteMessage(quote);
    await Clipboard.setData(ClipboardData(text: message));

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Quote copied to clipboard')),
    );
  }

  // SHARE: open the system share sheet with the formatted message
  Future<void> shareQuote(Quote quote) async {
    final message = formatQuoteMessage(quote);

    try {
      await SharePlus.instance.share(ShareParams(text: message));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sharing is not available here. Use Copy instead.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quote App')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder<Quote?>(
                future: quoteFuture,
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
                  final quote = snapshot.data;
                  if (quote == null) {
                    return messageView(
                      icon: Icons.inbox,
                      color: Colors.grey,
                      text: 'No quote was returned. Try again.',
                    );
                  }

                  // 4. SUCCESS
                  return Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Card(
                            elevation: 3,
                            child: Padding(
                              padding: const EdgeInsets.all(24),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.format_quote, size: 40),
                                  const SizedBox(height: 12),
                                  Text(
                                    quote.text,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    '- ${quote.author}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Copy and Share buttons, shown only when a quote exists
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              OutlinedButton.icon(
                                icon: const Icon(Icons.copy),
                                label: const Text('Copy'),
                                onPressed: () => copyQuote(quote),
                              ),
                              const SizedBox(width: 12),
                              OutlinedButton.icon(
                                icon: const Icon(Icons.share),
                                label: const Text('Share'),
                                onPressed: () => shareQuote(quote),
                              ),
                            ],
                          ),
                        ],
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
                label: const Text('New Quote'),
                onPressed: loadNewQuote,
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
