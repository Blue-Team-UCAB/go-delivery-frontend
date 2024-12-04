class PaymentMethod {
  final String? id;
  final String name;
  final double amount;
  final DateTime date;
  final String? reference;

  PaymentMethod({
    this.id,
    required this.name,
    required this.amount,
    required this.date,
    this.reference,
  });
}
