import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/event_provider.dart';
import '../utils/app_strings.dart';
import '../utils/extensions.dart';
import '../widgets/event_list.dart';
import '../widgets/state_views.dart';
import '../widgets/skeleton.dart';

class UpcomingTab extends StatefulWidget {
  const UpcomingTab({super.key});

  @override
  State<UpcomingTab> createState() => _UpcomingTabState();
}

class _UpcomingTabState extends State<UpcomingTab>
    with AutomaticKeepAliveClientMixin {
  final TextEditingController _controller = TextEditingController();
  String _query = '';

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); 

    final s = AppStrings.of(context);
    final provider = context.watch<EventProvider>();

    if (provider.isLoading) return const SkeletonList();

    if (provider.error != null) {
      return ErrorView(message: s.loadError, onRetry: provider.retry);
    }

    final results = provider.upcomingEvents.search(_query);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
          child: TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: s.searchEvents,
              prefixIcon: const Icon(Icons.search),
              isDense: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onChanged: (value) => setState(() => _query = value),
          ),
        ),
        Expanded(
          child: EventList(
            events: results,
            heroPrefix: 'upcoming',
            emptyIcon: _query.isEmpty ? Icons.event_busy : Icons.search_off,
            emptyMessage: _query.isEmpty ? s.noUpcoming : s.noSearchResults,
          ),
        ),
      ],
    );
  }
}
