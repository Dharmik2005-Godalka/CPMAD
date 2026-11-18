import 'package:flutter/material.dart';
import 'package:quotes_app/models/quotes.dart';
import 'package:quotes_app/services/api_call.dart';

class QuotesScreen extends StatefulWidget {
  const QuotesScreen({super.key});

  @override
  State<QuotesScreen> createState() => _QuotesScreenState();
}

class _QuotesScreenState extends State<QuotesScreen> {
  Quote quote = Quote(id:0, quote: '', author: '');

  @override
  void initState() {
    fetchData();
    super.initState();
  }

void fetchData() async {
  quote = await 
  APICall.fetchData();
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Quotes APP')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Quote', style: TextStyle(fontSize: 40)),
          Text('Author'),
        ],
      ),
    );
  }
}