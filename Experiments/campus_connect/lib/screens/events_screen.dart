import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/event.dart';
import '../providers/event_provider.dart';
import '../utils/app_routes.dart';
import '../utils/constants.dart';
import '../utils/extensions.dart';
import '../widgets/event_card.dart';
import '../widgets/state_views.dart';

class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<EventProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Events')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, AppRoutes.eventForm),
        icon: const Icon(Icons.add),
        label: const Text('Add'),
      ),
      body: _buildBody(context, provider),
    );
  }

  Widget _buildBody(BuildContext context, EventProvider provider) {
    if (provider.isLoading) return const LoadingView();

    if (provider.error != null) {
      return ErrorView(message: provider.error!, onRetry: provider.retry);
    }

    if (provider.events.isEmpty) {
      return const EmptyView(
        icon: Icons.event_busy,
        message: 'No events yet.\nTap Add to create the first one.',
      );
    }

    final events = provider.filteredEvents;

    return Column(
      children: [
        const _EventFilters(),
        Expanded(
          child: events.isEmpty
              ? const EmptyView(
                  icon: Icons.search_off,
                  message: 'No events match your filters',
                )
              : ListView.builder(
                  padding: const EdgeInsets.only(bottom: 90),
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    final event = events[index];
                    return EventCard(
                      key: ValueKey(event.id),
                      event: event,
                      isAttending: provider.isGoing(event),
                      onTap: () => _showDetails(context, event),
                      onRsvp: () => _rsvp(context, event),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Future<void> _rsvp(BuildContext context, Event event) async {
    final provider = context.read<EventProvider>();
    final messenger = ScaffoldMessenger.of(context);
    final wasGoing = provider.isGoing(event);

    try {
      await provider.toggleRsvp(event);
      messenger.hideCurrentSnackBar();
      messenger.showSnackBar(
        SnackBar(
          content: Text(wasGoing ? 'RSVP cancelled' : "You're going!"),
          duration: const Duration(seconds: 1),
        ),
      );
    } catch (_) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Could not update RSVP')),
      );
    }
  }

  void _showDetails(BuildContext context, Event event) {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(event.title, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              Text('${event.dateTime.formatDateTime()}  •  ${event.location}'),
              Text('By ${event.organizer}'),
              const SizedBox(height: 12),
              Text(event.description),
            ],
          ),
        ),
      ),
    );
  }
}

// const widget + select: only the chips / segments rebuild when a filter changes
class _EventFilters extends StatelessWidget {
  const _EventFilters();

  @override
  Widget build(BuildContext context) {
    final category =
        context.select<EventProvider, String>((p) => p.selectedCategory);
    final filter =
        context.select<EventProvider, EventFilter>((p) => p.filter);
    final provider = context.read<EventProvider>();
    final categories = ['All', ...kEventCategories];

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search events',
              prefixIcon: const Icon(Icons.search),
              isDense: true,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onChanged: provider.setSearchQuery,
          ),
        ),
        SizedBox(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final c = categories[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                child: ChoiceChip(
                  label: Text(c),
                  selected: category == c,
                  onSelected: (_) => provider.setCategory(c),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: SizedBox(
            width: double.infinity,
            child: SegmentedButton<EventFilter>(
              showSelectedIcon: false,
              segments: const [
                ButtonSegment(value: EventFilter.all, label: Text('All')),
                ButtonSegment(value: EventFilter.upcoming, label: Text('Upcoming')),
                ButtonSegment(value: EventFilter.going, label: Text('Going')),
              ],
              selected: {filter},
              onSelectionChanged: (s) => provider.setFilter(s.first),
            ),
          ),
        ),
        const SizedBox(height: 6),
      ],
    );
  }
}
