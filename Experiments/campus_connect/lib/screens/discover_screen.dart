import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/event.dart';
import '../providers/auth_provider.dart';
import '../providers/event_provider.dart';
import '../providers/public_event_provider.dart';
import '../services/event_sync_service.dart';
import '../utils/app_routes.dart';
import '../utils/app_strings.dart';
import '../utils/extensions.dart';
import '../widgets/category_header_delegate.dart';
import '../widgets/event_grid_card.dart';
import '../widgets/event_list_tile.dart';
import '../widgets/state_views.dart';
import 'event_details_screen.dart';
import '../widgets/skeleton.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  late Stream<EventsSnapshot> _stream;

  @override
  void initState() {
    super.initState();
    _stream = EventSyncService().watchEvents();
  }

  @override
  Widget build(BuildContext context) {
    final eventProvider = context.watch<EventProvider>();
    final publicProvider = context.watch<PublicEventProvider>();

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, AppRoutes.eventForm),
        icon: const Icon(Icons.add),
        label: const Text('New event'),
      ),

      body: StreamBuilder<EventsSnapshot>(
        stream: _stream,
        builder: (context, snapshot) {
          return CustomScrollView(
            slivers: [
              buildAppBar(context),
              ...buildFirestoreSlivers(context, snapshot, eventProvider),
              ...buildPublicSlivers(publicProvider),
              const SliverToBoxAdapter(child: SizedBox(height: 90)),
            ],
          );
        },
      ),
    );
  }

  // SliverAppBar
  Widget buildAppBar(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final name = context.read<AuthProvider>().displayName;

    return SliverAppBar(
      pinned: true,
      expandedHeight: 150,
      backgroundColor: colors.primary,
      foregroundColor: Colors.white,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsetsDirectional.only(start: 16, bottom: 14),
        title: Text(AppStrings.of(context).appTitle),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [colors.primary, colors.tertiary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 52),
          alignment: Alignment.bottomLeft,
          child: Text(
            'Hi, $name\n${DateTime.now().formatDate()}',
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        ),
      ),
    );
  }

  //Firestore section
  List<Widget> buildFirestoreSlivers(
    BuildContext context,
    AsyncSnapshot<EventsSnapshot> snapshot,
    EventProvider provider,
  ) {
    if (snapshot.hasError) {
      return [
        SliverToBoxAdapter(
          child: SizedBox(
            height: 220,
            child: ErrorView(
              message: 'Could not load events. Please try again.',
              onRetry: () {
                setState(() => _stream = EventSyncService().watchEvents());
              },
            ),
          ),
        ),
      ];
    }

    if (!snapshot.hasData) {
      return [
        SliverToBoxAdapter(
          child: Column(
            children: List<Widget>.generate(
              4,
              (index) => SkeletonCard(),
            ),
          ),
        ),
      ];
    }

    final data = snapshot.data!;
    final slivers = <Widget>[
      SliverToBoxAdapter(child: buildBanners(context, data, provider)),
    ];

    if (data.events.isEmpty) {
      slivers.add(
        const SliverToBoxAdapter(
          child: SizedBox(
            height: 200,
            child: EmptyView(
              icon: Icons.event_busy,
              message: 'No campus events yet.\nTap New event to create one.',
            ),
          ),
        ),
      );
      return slivers;
    }

    // Group the events by category
    final groups = <String, List<Event>>{};
    for (final event in data.events) {
      final name = event.category.isEmpty ? 'Other' : event.category;
      groups.putIfAbsent(name, () => []).add(event);
    }
    final names = groups.keys.toList()..sort();

    for (var i = 0; i < names.length; i++) {
      final list = groups[names[i]]!;
      list.sort((a, b) => a.dateTime.compareTo(b.dateTime));

      // Sticky header, then a grid or a list...
      slivers.add(
        SliverPersistentHeader(
          pinned: true,
          delegate: CategoryHeaderDelegate(
            title: names[i],
            count: list.length,
          ),
        ),
      );
      slivers.add(
        i.isEven
            ? buildGrid(context, list, data, provider)
            : buildList(context, list, data, provider),
      );
    }

    return slivers;
  }

  Widget buildGrid(
    BuildContext context,
    List<Event> list,
    EventsSnapshot data,
    EventProvider provider,
  ) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 220,
          childAspectRatio: 0.85,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final event = list[index];
            return EventGridCard(
              event: event,
              heroTag: 'home-${event.id}',
              isPending: data.pendingIds.contains(event.id),
              isGoing: provider.isGoing(event),
              onTap: () => openDetails(context, event),
            );
          },
          childCount: list.length,
        ),
      ),
    );
  }

  Widget buildList(
    BuildContext context,
    List<Event> list,
    EventsSnapshot data,
    EventProvider provider,
  ) {
    return SliverPadding(
      padding: const EdgeInsets.only(top: 4, bottom: 8),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final event = list[index];
            return EventListTile(
              event: event,
              heroTag: 'home-${event.id}',
              isPending: data.pendingIds.contains(event.id),
              isGoing: provider.isGoing(event),
              onTap: () => openDetails(context, event),
            );
          },
          childCount: list.length,
        ),
      ),
    );
  }

  void openDetails(BuildContext context, Event event) {
    Navigator.pushNamed(
      context,
      AppRoutes.eventDetails,
      arguments: EventDetailsArgs(event: event, heroTag: 'home-${event.id}'),
    );
  }

  // ---------- Offline / sync banners ----------
  Widget buildBanners(
    BuildContext context,
    EventsSnapshot data,
    EventProvider provider,
  ) {
    return Column(
      children: [
        if (data.fromCache)
          buildBanner(
            context,
            icon: Icons.cloud_off,
            text: data.pendingIds.isEmpty
                ? 'Offline: showing saved events.'
                : 'Offline: ${data.pendingIds.length} change(s) will sync when you reconnect.',
          ),
        if (provider.syncError != null)
          buildBanner(
            context,
            icon: Icons.error_outline,
            text: provider.syncError!,
            onDismiss: provider.clearSyncError,
          ),
      ],
    );
  }

  Widget buildBanner(
    BuildContext context, {
    required IconData icon,
    required String text,
    VoidCallback? onDismiss,
  }) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(12, 8, 12, 0),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.tertiaryContainer,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: colors.onTertiaryContainer),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: colors.onTertiaryContainer),
            ),
          ),
          if (onDismiss != null)
            TextButton(onPressed: onDismiss, child: const Text('Dismiss')),
        ],
      ),
    );
  }

  //API 
  List<Widget> buildPublicSlivers(PublicEventProvider provider) {
    final Widget body;

    if (provider.isLoading) {
      body = SliverToBoxAdapter(
        child: Column(
          children: List<Widget>.generate(
            3,
            (index) => SkeletonCard(),
          ),
        ),
      );
    }
    else if (provider.error != null) {
      body = SliverToBoxAdapter(
        child: SizedBox(
          height: 200,
          child: ErrorView(message: provider.error!, onRetry: provider.retry),
        ),
      );
    } else if (provider.events.isEmpty) {
      body = const SliverToBoxAdapter(
        child: SizedBox(
          height: 160,
          child: EmptyView(
            icon: Icons.public_off,
            message: 'No public events found',
          ),
        ),
      );
    } else {
      body = SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final event = provider.events[index];
            return EventListTile(
              event: event,
              heroTag: 'public-${event.id}',
              isPending: false,
              isGoing: false,
            );
          },
          childCount: provider.events.length,
        ),
      );
    }

    return [
      SliverPersistentHeader(
        pinned: true,
        delegate: CategoryHeaderDelegate(
          title: 'Public events (online feed)',
          count: provider.events.length,
        ),
      ),
      body,
    ];
  }
}
