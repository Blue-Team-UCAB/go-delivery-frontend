class PaymentMethod {
  final String? id;
  final String? name;
  final double? amount;
  final DateTime? date;
  final String? reference;
  final String? state;
  final String? image;

  PaymentMethod(
      {this.id,
      this.name,
      this.amount,
      this.date,
      this.reference,
      this.state,
      this.image});
}
