import 'package:go_delivery_frontend/domain/entities/bundle/bundle.dart';
import 'package:go_delivery_frontend/domain/entities/category/category.dart';
import 'package:go_delivery_frontend/domain/entities/discount/discount.dart';
import 'package:go_delivery_frontend/infrastructure/mappers/bundle/bundle_product_mapper.dart';

class BundleMapper {
  // Parse list of bundles
  static List<Bundle> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((bundleJson) => fromJson(bundleJson)).toList();
  }

  // Parse single bundle
  static Bundle fromJson(Map<String, dynamic> json) {
    return Bundle(
      id: json['id'],
      name: json['name'] as String,
      description: json['description'] as String,
      currency: json['currency'] as String,
      price: _parseDouble(json['price']),
      stock: json['stock'] != null ? json['stock'] as int : null,
      weight: json['weight'] != null ? _parseDouble(json['weight']) : null,
      measurement: json['measurement'],
      images: _parseImages(json['images']),
      caducityDate: json['caducityDate'] != null
          ? DateTime.parse(json['caducityDate'])
          : null,
      products: json['product'] != null
          ? BundleProductMapper.fromJsonList(json['product'])
          : null,
      categories:
          json['category'] != null ? _parseCategories(json['category']) : null,
      discounts:
          json['discount'] != null ? _parseDiscounts(json['discount']) : null,
    );
  }

  // Parsing helper methods
  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is int) return value.toDouble();
    if (value is double) return value;
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  static List<String> _parseImages(dynamic images) {
    if (images == null) return [];
    if (images is List) {
      return images.map((image) => image.toString()).toList();
    }
    return [];
  }

  static List<Category> _parseCategories(dynamic categories) {
    if (categories == null) return [];
    if (categories is List) {
      return categories
          .map((categoryJson) => _parseCategory(categoryJson))
          .toList();
    }
    return [];
  }

  static Category _parseCategory(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as String,
      name: json['name'] as String,
      image: '',
    );
  }

  static List<Discount> _parseDiscounts(dynamic discounts) {
    if (discounts == null) return [];
    if (discounts is List) {
      return discounts
          .map((discountJson) => _parseDiscount(discountJson))
          .toList();
    }
    return [];
  }

  static Discount _parseDiscount(Map<String, dynamic> json) {
    return Discount(
      id: json['id'] as String,
      percentage: json['percentage'] as double,
    );
  }

  // To JSON method
  static Map<String, dynamic> toJson(Bundle bundle) {
    return {
      'id': bundle.id,
      'name': bundle.name,
      'description': bundle.description,
      'currency': bundle.currency,
      'price': bundle.price,
      'stock': bundle.stock,
      'weight': bundle.weight,
      'measurement': bundle.measurement,
      'images': bundle.images,
      'caducityDate': bundle.caducityDate?.toIso8601String(),
      'product': bundle.products?.map(BundleProductMapper.toJson).toList(),
      'category': bundle.categories?.map(_categoryToJson).toList(),
      'discount': bundle.discounts?.map(_discountToJson).toList(),
    };
  }

  // Helper methods for JSON conversion
  static Map<String, dynamic> _categoryToJson(Category category) {
    return {
      'id': category.id,
      'name': category.name,
    };
  }

  static Map<String, dynamic> _discountToJson(Discount discount) {
    return {
      'id': discount.id,
      'percentage': discount.percentage,
    };
  }
}
