class Student {
  String name;
  int rollNumber;

  Map<String, double> subjectMarks;

  Student({
    required this.name,
    required this.rollNumber,
    required this.subjectMarks,
  });

  double calculateTotal() {
    double total = 0;
    for (var marks in subjectMarks.values) {
      total = total + marks;
    }
    return total;
  }

  double calculatePercentage() {
    int totalSubjects = subjectMarks.length;
    double maxMarks = totalSubjects * 100;
    double percentage = (calculateTotal() / maxMarks) * 100;
    return percentage;
  }

  String calculateGrade() {
    double percentage = calculatePercentage();

    if (percentage >= 90) {
      return 'A+';
    } else if (percentage >= 80) {
      return 'A';
    } else if (percentage >= 70) {
      return 'B';
    } else if (percentage >= 60) {
      return 'C';
    } else if (percentage >= 40) {
      return 'D';
    } else {
      return 'F';
    }
  }

  bool isPass() {
    return calculatePercentage() >= 40;
  }

  List<String> failedSubjects() {
    List<String> failed = [];
    subjectMarks.forEach((subject, marks) {
      if (marks < 40) {
        failed.add(subject);
      }
    });
    return failed;
  }
}