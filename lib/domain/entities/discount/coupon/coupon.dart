class Coupon {
  final String id;
  final String code;
  final String discountType;
  final double discountValue;
  final String? appliesTo;
  final String? targetId;
  final DateTime? startDate;
  final DateTime? endDate;
  final int? maxRedemptions;
  final int remainingRedemptions;

  Coupon({
    required this.id,
    required this.code,
    required this.discountType,
    required this.discountValue,
    this.appliesTo,
    this.targetId,
    this.startDate,
    this.endDate,
    this.maxRedemptions,
    required this.remainingRedemptions,
  });
}
