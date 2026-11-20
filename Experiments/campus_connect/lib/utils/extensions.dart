import '../models/event.dart';
import '../models/note.dart';

const List<String> _months = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
];

extension DateFormatting on DateTime 
{
  String formatDate() => '$day ${_months[month - 1]} $year';

  String formatTime() {
    final hour12 = hour % 12 == 0 ? 12 : hour % 12;
    final minuteText = minute.toString().padLeft(2, '0');
    final suffix = hour < 12 ? 'AM' : 'PM';
    return '$hour12:$minuteText $suffix';
  }

  String formatDateTime() => '${formatDate()}, ${formatTime()}';

  bool isSameDay(DateTime other) 
  {
    return year == other.year && month == other.month && day == other.day;
  }

  String relativeDay() 
  {
    final now = DateTime.now();
    if (isSameDay(now)) return 'Today';
    if (isSameDay(now.add(const Duration(days: 1)))) return 'Tomorrow';
    if (isSameDay(now.subtract(const Duration(days: 1)))) return 'Yesterday';
    return formatDate();
  }

  String timeAgo() 
  {
    final diff = DateTime.now().difference(this);
    if (diff.inMinutes < 1) 
    {
      return 'Just now';
    }
    if (diff.inMinutes < 60) 
    {
      return '${diff.inMinutes} min ago';
    }
    if (diff.inHours < 24) 
    {
      return '${diff.inHours} hr ago';
    }
    if (diff.inDays < 7) 
    {
      return '${diff.inDays} days ago';
    }
    return formatDate();
  }
}

extension StringSearch on String 
{
  bool containsIgnoreCase(String query) 
  {
    return toLowerCase().contains(query.toLowerCase());
  }

  bool matchesQuery(String query) 
  {
    final text = toLowerCase();
    final words = query.toLowerCase().split(' ').where((w) => w.isNotEmpty);
    return words.every((word) => text.contains(word));
  }
}

extension EventSearch on List<Event> 
{
  List<Event> search(String query) 
  {
    if (query.trim().isEmpty) return this;
    return where((e) 
    {
      return '${e.title} ${e.description} ${e.location} ${e.category} ${e.organizer}'
          .matchesQuery(query);
    }).toList();
  }
}

extension NoteSearch on List<Note> 
{
  List<Note> search(String query) 
  {
    if (query.trim().isEmpty) return this;
    return where((n) => '${n.title} ${n.content}'.matchesQuery(query)).toList();
  }
}
