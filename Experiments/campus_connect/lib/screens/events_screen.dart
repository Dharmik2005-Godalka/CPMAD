import 'package:flutter/material.dart';
import '../utils/app_strings.dart';
import '../widgets/app_drawer.dart';
import 'my_events_tab.dart';
import 'notes_tab.dart';
import 'upcoming_tab.dart';

class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(s.events),
          bottom: TabBar(
            tabs: [
              Tab(text: s.upcoming),
              Tab(text: s.myEvents),
              Tab(text: s.notes),
            ],
          ),
        ),
        drawer: const AppDrawer(),
        body: const TabBarView(
          children: [
            UpcomingTab(),
            MyEventsTab(),
            NotesTab(),
          ],
        ),
      ),
    );
  }
}
