import 'package:flutter/material.dart';
import 'chat_screen.dart';

class NameScreen extends StatefulWidget 
{
  const NameScreen({super.key});

  @override
  State<NameScreen> createState() => _NameScreenState();
}

class _NameScreenState extends State<NameScreen> 
{
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() 
  {
    _nameController.dispose();
    super.dispose();
  }

  void _enterChat() 
  {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ChatScreen(userName: name)),
    );
  }

  @override
  Widget build(BuildContext context) 
  {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.chat, size: 80, color: Colors.green),
              const SizedBox(height: 16),
              const Text(
                'Real-Time Chat',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Enter your name',
                  border: OutlineInputBorder(),
                ),
                onSubmitted: (_) => _enterChat(),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _enterChat,
                  child: const Text('Join Chat'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
