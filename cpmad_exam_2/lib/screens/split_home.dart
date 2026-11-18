import 'package:flutter/material.dart';

import '../services/history_storage.dart';
import 'calculator_page.dart';
import 'history_page.dart';
import 'tips_page.dart';

/// Home of SplitEase: app bar with tabs, drawer and the three tab pages.
class SplitHome extends StatefulWidget {
  const SplitHome({super.key});

  @override
  State<SplitHome> createState() => _SplitHomeState();
}

class _SplitHomeState extends State<SplitHome> {
  final HistoryStorage _storage = HistoryStorage();
  List<String> history = [];

  // ---------------------------------------------------------- persistence
  // >>> Q7A2 START
  @override
  void initState() {
    super.initState();
    // TODO (Q7-A): start loading the saved history here
  }

  Future<void> _load() async {
    // TODO (Q7-A)
  }

  Future<void> _saveEntry(String entry) async {
    // TODO (Q7-A): newest first, keep only 5, persist
  }

  Future<void> _clear() async {
    // TODO (Q7-A): empty the list and the storage
  }
  // <<< Q7A2 END

  // ----------------------------------------------------------- navigation
  // >>> Q6B2 START
  Future<void> _openSettings() async {
    // TODO (Q6-B): open '/settings' and handle the returned values
  }
  // <<< Q6B2 END

  // ----------------------------------------------------------------- view
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('SplitEase'),
      actions: [
        // >>> Q6B1 START
        // TODO (Q6-B): Settings icon button
        // <<< Q6B1 END
      ],
      bottom: const TabBar(
        tabs: [
          Tab(icon: Icon(Icons.calculate), text: 'Calculator'),
          Tab(icon: Icon(Icons.history), text: 'History'),
          // >>> Q6A2 START
          Tab(icon: Icon(Icons.lightbulb_outline), text: 'Tips'),
          // <<< Q6A2 END
        ],
      ),
    );
  }

  Widget? _buildDrawer() {
    // >>> Q6A4 START
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Colors.green),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: const [
                Icon(Icons.receipt_long, color: Colors.white, size: 40),
                Text('SplitEase',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold)),
                Text('Split bills, not friendships',
                    style: TextStyle(color: Colors.white70)),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About SplitEase'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/about');
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete_outline),
            title: const Text('Clear history'),
            onTap: () {
              Navigator.pop(context);
              _clear();
            },
          ),
        ],
      ),
    );
    // <<< Q6A4 END
  }

  Widget _buildBody() {
    return TabBarView(
      children: [
        CalculatorPage(onSave: _saveEntry),
        HistoryPage(history: history, onClear: _clear),
        // >>> Q6A3 START
        TipsPage(),
        // <<< Q6A3 END
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      // >>> Q6A1 START
      length: 3,
      // <<< Q6A1 END
      child: Scaffold(
        appBar: _buildAppBar(),
        drawer: _buildDrawer(),
        body: _buildBody(),
      ),
    );
  }
}
