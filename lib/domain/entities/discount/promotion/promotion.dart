class Promotion {
  final String id;
  final String title;
  final String? description;
  final double discountValue;
  final String targetId;
  final DateTime? startDate;
  final DateTime? endDate;

  Promotion({
    required this.id,
    required this.title,
    this.description,
    required this.discountValue,
    required this.targetId,
    this.startDate,
    this.endDate,
  });
}
