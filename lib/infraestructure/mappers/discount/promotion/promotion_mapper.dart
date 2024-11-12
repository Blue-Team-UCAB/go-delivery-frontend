import 'package:go_delivery_frontend/domain/entities/discount/promotion/promotion.dart';

class PromotionMapper {
  static Promotion fromJson(Map<String, dynamic> json) {
    return Promotion(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      discountValue: (json['discountValue'] as num).toDouble(),
      targetId: json['targetId'] as String,
      startDate: json['startDate'] != null
          ? DateTime.parse(json['startDate'] as String)
          : null,
      endDate: json['endDate'] != null
          ? DateTime.parse(json['endDate'] as String)
          : null,
    );
  }

  static Map<String, dynamic> toJson(Promotion promotion) {
    return {
      'id': promotion.id,
      'title': promotion.title,
      'description': promotion.description,
      'discountValue': promotion.discountValue,
      'targetId': promotion.targetId,
      'startDate': promotion.startDate?.toIso8601String(),
      'endDate': promotion.endDate?.toIso8601String(),
    };
  }
}
