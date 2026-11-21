import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quotes_app/screens/quotes_list_screen.dart';
import '../controllers/quotes_controller.dart';

class QuotesScreen extends StatelessWidget 
{
  QuotesScreen({super.key});
  final QuoteController controller = Get.put(QuoteController());

  @override
  Widget build(BuildContext context) 
  {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QuoteScreen'),
        actions: [
          IconButton(
            onPressed: () 
            {
              Get.to(() => QuotesListScreen());
            },
            icon: const Icon(Icons.menu),
          ),
        ],
      ),
      body: Obx(() 
      {
        return controller.quotes.isNotEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    controller.quotes[0].q,
                    style: const TextStyle(fontSize: 40),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    controller.quotes[0].a,
                    style: const TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                ],
              )
            : const Center(child: CircularProgressIndicator());
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.fetchDetails();
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
