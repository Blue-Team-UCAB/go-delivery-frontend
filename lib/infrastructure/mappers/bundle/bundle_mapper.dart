import 'package:go_delivery_frontend/domain/entities/bundle/bundle.dart';
import 'package:go_delivery_frontend/domain/entities/bundle/bundle_product.dart';
import 'package:go_delivery_frontend/domain/entities/category/category.dart';
import 'package:go_delivery_frontend/domain/entities/discount/discount.dart';

class BundleMapper {
  // Parse list of bundles
  static List<Bundle> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((bundleJson) => fromJson(bundleJson))
        .toList()
        .whereType<Bundle>()
        .toList();
  }

  // Parse single bundle with improved null safety and error handling
  static Bundle fromJson(Map<String, dynamic>? json) {
    // Throw an error if json is null
    if (json == null) {
      throw ArgumentError('Cannot parse Bundle from null JSON');
    }

    return Bundle(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      currency: _parseCurrency(json['currency']),
      price: _parseDouble(json['price']),
      stock: _parseInt(json['stock']),
      weight: _parseDouble(json['weight']),
      measurement: _parseMeasurement(json['measurement']),
      images: _parseImages(json['images']),
      caducityDate: _parseDate(json['caducityDate']),
      products: _parseProducts(json['product']),
      categories: _parseCategories(json['category']),
      discounts: _parseDiscounts(json['discount']),
    );
  }

  // Enhanced parsing methods with more robust type checking
  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  static List<String> _parseImages(dynamic images) {
    if (images == null) return [];
    if (images is List) {
      return images
          .map((image) => image?.toString() ?? '')
          .where((image) => image.isNotEmpty)
          .toList();
    }
    return [];
  }

  static DateTime? _parseDate(dynamic dateString) {
    if (dateString == null) return null;
    try {
      return DateTime.parse(dateString.toString());
    } catch (e) {
      return null;
    }
  }

  static List<Category> _parseCategories(dynamic categories) {
    if (categories == null) return [];
    if (categories is List) {
      return categories
          .map((categoryJson) => _parseCategory(categoryJson))
          .whereType<Category>()
          .toList();
    }
    return [];
  }

  static Category? _parseCategory(Map<String, dynamic>? json) {
    if (json == null) return null;
    return Category(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      imageUrl: json['imageUrl']?.toString() ?? '',
    );
  }

  static List<Discount> _parseDiscounts(dynamic discounts) {
    if (discounts == null) return [];
    if (discounts is List) {
      return discounts
          .map((discountJson) => _parseDiscount(discountJson))
          .whereType<Discount>()
          .toList();
    }
    return [];
  }

  static Discount? _parseDiscount(Map<String, dynamic>? json) {
    if (json == null) return null;
    return Discount(
      id: json['id']?.toString() ?? '',
      percentage: _parseDouble(json['percentage']),
    );
  }

  static List<BundleProduct> _parseProducts(dynamic products) {
    if (products == null) return [];
    if (products is List) {
      return products
          .map((productJson) => _parseProduct(productJson))
          .whereType<BundleProduct>()
          .toList();
    }
    return [];
  }

  static BundleProduct? _parseProduct(Map<String, dynamic>? json) {
    if (json == null) return null;

    return BundleProduct(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      price: _parseDouble(json['price']),
      weight: _parseDouble(json['weight']),
      quantity: _parseInt(json['quantity']),
      images: _parseImages(json['images']),
    );
  }

  // Additional parsing methods for specific types
  static String _parseCurrency(dynamic currency) {
    final validCurrencies = ['usd', 'bsf', 'eur'];

    // Handle null or empty input
    if (currency == null) return 'usd';

    // Convert to string and trim
    final parsedCurrency = currency.toString().trim().toLowerCase();

    // Return valid currency or default to 'usd'
    return validCurrencies.contains(parsedCurrency)
        ? parsedCurrency
        : 'usd';
  }

  static String? _parseMeasurement(dynamic measurement) {
    final validMeasurements = ['kg', 'gr', 'mg', 'ml', 'lt', 'cm3'];
    final parsedMeasurement = measurement?.toString().toLowerCase();
    return validMeasurements.contains(parsedMeasurement)
        ? parsedMeasurement
        : 'kg';
  }

  // To JSON method with null safety
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
      'product': bundle.products?.map(_productToJson).toList(),
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

  static Map<String, dynamic> _productToJson(BundleProduct product) {
    return {
      'id': product.id,
      'name': product.name,
      'price': product.price,
      'weight': product.weight,
      'quantity': product.quantity,
      'images': product.images,
    };
  }
}