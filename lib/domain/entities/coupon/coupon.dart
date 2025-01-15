class Coupon {
  final String id;
  final int porcentage;
  final String? code;
  final DateTime? expirationDate;
  final int? numberUses;
  final DateTime? startDate;
  final CouponMessage? message;
  final List<CustomerUsage>? customers;

  const Coupon({
    required this.id,
    required this.porcentage,
    this.code,
    this.expirationDate,
    this.numberUses,
    this.startDate,
    this.message,
    this.customers,
  });

  Coupon copyWith({
    String? id,
    int? porcentage,
    String? code,
    DateTime? expirationDate,
    int? numberUses,
    DateTime? startDate,
    CouponMessage? message,
    List<CustomerUsage>? customers,
  }) => Coupon(
    id: id ?? this.id,
    porcentage: porcentage ?? this.porcentage,
    code: code ?? this.code,
    expirationDate: expirationDate ?? this.expirationDate,
    numberUses: numberUses ?? this.numberUses,
    startDate: startDate ?? this.startDate,
    message: message ?? this.message,
    customers: customers ?? this.customers,
  );
}

class CustomerUsage {
  final String idCustomer;
  final int remainingUses;

  const CustomerUsage({
    required this.idCustomer,
    required this.remainingUses
  });

  factory CustomerUsage.fromJson(Map<String, dynamic> json) {
    return CustomerUsage(
      idCustomer: json['id_customer'] as String,
      remainingUses: json['remaining_uses'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_customer': idCustomer,
      'remaining_uses': remainingUses,
    };
  }
}

class CouponMessage {
  final String? title;
  final String? message;

  const CouponMessage({this.title, this.message});

  factory CouponMessage.fromJson(Map<String, dynamic> json) {
    return CouponMessage(
      title: json['title'] as String?,
      message: json['message'] as String?,
    );

  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'message': message,
    };
  }
}