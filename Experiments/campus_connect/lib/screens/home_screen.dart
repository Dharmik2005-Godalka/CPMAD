import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/student_provider.dart';
import 'settings_screen.dart';
import 'student_list_screen.dart';
import 'dashboard_screen.dart';
import 'events_screen.dart';
import '../providers/event_provider.dart';
import '../providers/note_provider.dart';
import 'notes_screen.dart';
import '../providers/public_event_provider.dart';
import 'discover_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;

  final List<Widget> _pages = const [
    DiscoverScreen(),     // Home
    EventsScreen(),       // Events
    StudentListScreen(),  // Students
    DashboardScreen(),    // Dashboard
    SettingsScreen(),     // Settings
    NotesScreen(),        // Notes
  ];

  @override
  void initState() {
    super.initState();
    context.read<StudentProvider>().listen();
    context.read<EventProvider>().listen();
    context.read<NoteProvider>().listen();
    context.read<PublicEventProvider>().load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
                destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.event_outlined),
            selectedIcon: Icon(Icons.event),
            label: 'Events',
          ),
          NavigationDestination(
            icon: Icon(Icons.school_outlined),
            selectedIcon: Icon(Icons.school),
            label: 'Students',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
          NavigationDestination(
            icon: Icon(Icons.note_alt_outlined),
            selectedIcon: Icon(Icons.note_alt),
            label: 'Notes',
          ),
        ],
      ),
    );
  }
}
