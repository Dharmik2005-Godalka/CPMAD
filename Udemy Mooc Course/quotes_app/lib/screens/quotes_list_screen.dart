import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/quotes_controller.dart';

class QuotesListScreen extends StatelessWidget 
{
  QuotesListScreen({super.key});

  final QuoteController controller = Get.find<QuoteController>();

  @override
  Widget build(BuildContext context) 
  {
    return Scaffold(
      appBar: AppBar(title: const Text('Quotes List')),
      body: Obx(
        () => controller.quotes.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: controller.quotes.length,
                itemBuilder: (context, index) {
                  final quote = controller.quotes[index];

                  return ListTile(
                    title: Text(quote.q),
                    subtitle: Text(quote.a),
                  );
                },
              ),
      ),
    );
  }
}
