// >>> Q1 START
/// bill + tip + (18% GST when includeGst is true)
double calcTotal(double amount, double tipPercent, bool includeGst) {
  double tip = amount * tipPercent / 100;
  double gst = 0;
  if (includeGst) 
  {
    gst = amount *18/100;
  }
  return amount + tip + gst;
}

/// Share of every person, rounded to 2 decimals (0 when people <= 0).
double perPerson(double total, int people) {
  if (people <= 0) 
  {
    return 0;
  }
  double share = total / people;
  return double.parse(share.toStringAsFixed(2));
}

/// 0 -> 'No tip', below 15 -> 'Standard', below 20 -> 'Generous', else 'Very generous'
String tipLabel(double percent) {
  if (percent <= 0) 
  {
    return 'No tip';
  } 
  else if (percent < 15) 
  {
    return 'Standard';
  } 
  else if (percent < 20) 
  {
    return 'Generous';
  } 
  else 
  {
    return 'Very generous';
  }
}
// <<< Q1 END

/// Text stored in the history for one saved split, e.g. `₹1000 • 2 people • ₹550.00 each`.
String formatSplitEntry({
  required double billAmount,
  required int people,
  required double perHead,
}) {
  return '₹${billAmount.toStringAsFixed(0)} • $people people • '
      '₹${perHead.toStringAsFixed(2)} each';
}
