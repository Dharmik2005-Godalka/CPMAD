/// Values of the calculator that can be remembered between launches.
class CalcSettings {
  const CalcSettings({
    this.tip = 10,
    this.people = 2,
    this.gst = false,
    this.amount = '',
  });

  final double tip;
  final int people;
  final bool gst;
  final String amount;
}
