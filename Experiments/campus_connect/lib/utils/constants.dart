const List<String> kDepartments = 
[
  'Computer',
  'IT',
  'Mechanical',
  'Civil',
  'Electrical',
  'Electronics',
];

// 1 -> 1st Year like this all
String yearLabel(int year) 
{
  const suffix = {1: 'st', 2: 'nd', 3: 'rd'};
  return '$year${suffix[year] ?? 'th'} Year';
}

enum StudentSort { nameAsc, nameDesc, rollNo, year }

String sortLabel(StudentSort sort) 
{
  switch (sort) 
  {
    case StudentSort.nameAsc:
      return 'Name (A-Z)';
    case StudentSort.nameDesc:
      return 'Name (Z-A)';
    case StudentSort.rollNo:
      return 'Roll number';
    case StudentSort.year:
      return 'Year';
  }
}

const List<String> kEventCategories = [
  'Tech', 'Academic', 'Cultural', 'Sports', 'Other',
];

enum EventFilter { all, upcoming, going }

enum NoteFilter { all, pinned }
