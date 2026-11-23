import 'dart:async';
import 'package:flutter/material.dart';
import '../models/student.dart';
import '../services/student_service.dart';
import '../utils/constants.dart';
import '../utils/error_messages.dart';

class StudentProvider extends ChangeNotifier 
{
  final StudentService _service = StudentService();
  StreamSubscription<List<Student>>? _subscription;

  List<Student> _students = [];
  bool _isLoading = true;
  String? _error;
  String _searchQuery = '';
  String _selectedDepartment = 'All';
  int _selectedYear = 0; 
  StudentSort _sort = StudentSort.nameAsc;

  static const Duration _writeTimeout = Duration(seconds: 15);

  List<Student> get students => _students;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get selectedDepartment => _selectedDepartment;
  int get selectedYear => _selectedYear;
  StudentSort get sort => _sort;

  bool get hasActiveFilters =>
      _selectedDepartment != 'All' ||
      _selectedYear != 0 ||
      _sort != StudentSort.nameAsc;

  // Derived state: search + department + year, then sorted
  List<Student> get filteredStudents {
    final result = _students.where((s) {
      final matchesDepartment =
          _selectedDepartment == 'All' || s.department == _selectedDepartment;
      final matchesYear = _selectedYear == 0 || s.year == _selectedYear;
      final matchesSearch = _searchQuery.isEmpty ||
          s.name.toLowerCase().contains(_searchQuery) ||
          s.rollNo.toLowerCase().contains(_searchQuery) ||
          s.email.toLowerCase().contains(_searchQuery);
      return matchesDepartment && matchesYear && matchesSearch;
    }).toList();

    switch (_sort) {
      case StudentSort.nameAsc:
        result.sort(
          (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
        );
        break;
      case StudentSort.nameDesc:
        result.sort(
          (a, b) => b.name.toLowerCase().compareTo(a.name.toLowerCase()),
        );
        break;
      case StudentSort.rollNo:
        result.sort(
          (a, b) => a.rollNo.toLowerCase().compareTo(b.rollNo.toLowerCase()),
        );
        break;
      case StudentSort.year:
        result.sort((a, b) {
          final byYear = a.year.compareTo(b.year);
          return byYear != 0
              ? byYear
              : a.name.toLowerCase().compareTo(b.name.toLowerCase());
        });
        break;
    }

    return result;
  }

  int get totalStudents => _students.length;

  Map<String, int> get countByDepartment {
    final counts = {for (final d in kDepartments) d: 0};
    for (final s in _students) {
      counts[s.department] = (counts[s.department] ?? 0) + 1;
    }
    return counts;
  }

  Map<int, int> get countByYear {
    final counts = {1: 0, 2: 0, 3: 0, 4: 0};
    for (final s in _students) {
      counts[s.year] = (counts[s.year] ?? 0) + 1;
    }
    return counts;
  }

  int get departmentsInUse =>
      countByDepartment.values.where((count) => count > 0).length;

  String? get topDepartment {
    String? top;
    var best = 0;
    for (final entry in countByDepartment.entries) {
      if (entry.value > best) {
        best = entry.value;
        top = entry.key;
      }
    }
    return top;
  }

  Student? getById(String id) 
  {
    for (final student in _students) 
    {
      if (student.id == id) return student;
    }
    return null;
  }

  bool rollNoExists(String rollNo, {String? exceptId}) 
  {
    return _students.any(
      (s) =>
          s.rollNo.toLowerCase() == rollNo.toLowerCase() && s.id != exceptId,
    );
  }

  void listen() 
  {
    _subscription?.cancel();
    _isLoading = true;
    _error = null;

    _subscription = _service.getStudents().listen(
      (data) {
        _students = data;
        _isLoading = false;
        _error = null;
        notifyListeners();
      },
      onError: (error) {
        _error = friendlyError(error);
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  void retry() 
  {
    listen();
    notifyListeners();
  }

  void stop() 
  {
    _subscription?.cancel();
    _subscription = null;
    _students = [];
    _isLoading = true;
    _error = null;
    _searchQuery = '';
    _selectedDepartment = 'All';
    _selectedYear = 0;
    _sort = StudentSort.nameAsc;
    notifyListeners();
  }

  void setSearchQuery(String query) 
  {
    _searchQuery = query.trim().toLowerCase();
    notifyListeners();
  }

  void setDepartment(String department) 
  {
    _selectedDepartment = department;
    notifyListeners();
  }

    void setYear(int year) {
    _selectedYear = year;
    notifyListeners();
  }

  void setSort(StudentSort sort) {
    _sort = sort;
    notifyListeners();
  }

  void resetFilters() {
    _selectedDepartment = 'All';
    _selectedYear = 0;
    _sort = StudentSort.nameAsc;
    notifyListeners();
  }

  Future<void> addStudent(Student student) 
  {
    return _service.addStudent(student).timeout(_writeTimeout);
  }

  Future<void> updateStudent(Student student) 
  {
    return _service.updateStudent(student).timeout(_writeTimeout);
  }

  Future<void> deleteStudent(String id) 
  {
    return _service.deleteStudent(id).timeout(_writeTimeout);
  }

  @override
  void dispose() 
  {
    _subscription?.cancel();
    super.dispose();
  }
}
