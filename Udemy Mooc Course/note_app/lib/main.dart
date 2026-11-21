import 'package:flutter/material.dart';
import 'screens/note_list_screen.dart';

void main() 
{
  runApp(const NotesApp());
}

class NotesApp extends StatelessWidget 
{
  const NotesApp({super.key});

  @override
  Widget build(BuildContext context) 
  {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Notes App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const NoteListScreen(),
    );
  }
}
