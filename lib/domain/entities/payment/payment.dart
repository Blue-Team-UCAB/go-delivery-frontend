class Payment {
  final String type;
  final DateTime date;
  final double amount;
  final String method;
  final bool debit;

  Payment({
    required this.type,
    required this.date,
    required this.amount,
    required this.method,
    required this.debit,
  });
}
