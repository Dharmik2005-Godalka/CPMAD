import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/event_provider.dart';
import '../utils/app_strings.dart';
import '../widgets/event_list.dart';
import '../widgets/state_views.dart';
import '../widgets/skeleton.dart';

class MyEventsTab extends StatelessWidget 
{
  const MyEventsTab({super.key});

  @override
  Widget build(BuildContext context) 
  {
    final s = AppStrings.of(context);
    final provider = context.watch<EventProvider>();

    if (provider.isLoading) return const SkeletonList();

    if (provider.error != null) 
    {
      return ErrorView(message: s.loadError, onRetry: provider.retry);
    }

    return EventList(
      events: provider.myEvents,
      heroPrefix: 'mine',
      emptyIcon: Icons.bookmark_border,
      emptyMessage: s.noMyEvents,
    );
  }
}
