class Transaction {
  double amount;
  String note;
  bool isIncome;
  DateTime date;

  Transaction(this.amount, this.note, this.isIncome, this.date);

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'note': note,
      'isIncome': isIncome,
      'date': date.toIso8601String(),
    };
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      (map['amount'] as num).toDouble(),
      map['note'],
      map['isIncome'],
      DateTime.parse(map['date']),
    );
  }
}