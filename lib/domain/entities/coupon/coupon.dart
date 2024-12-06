class Coupon{
  final String id;
  final int porcentage;

  const Coupon({
    required this.id,
    required this.porcentage
  });

  Coupon copyWith({
    String? id,
    int? porcentage,
  }) => Coupon(
    id: id ?? this.id, 
    porcentage: porcentage ?? this.porcentage
    );

}