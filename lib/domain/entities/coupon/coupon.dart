class Coupon{
  final String id;
  final int porcentage;
  final String? code;
  final DateTime? expirationDate;
  final int? numberUses;

  const Coupon({
    required this.id,
    required this.porcentage,
    this.code,
    this.expirationDate,
    this.numberUses
  });

  Coupon copyWith({
    String? id,
    int? porcentage,
    String? code,
    DateTime? expirationDate,
    int? numberUses
  }) => Coupon(
    id: id ?? this.id, 
    porcentage: porcentage ?? this.porcentage,
    code: code?? this.code,
    expirationDate: expirationDate?? this.expirationDate,
    numberUses: numberUses?? this.numberUses
    );

}