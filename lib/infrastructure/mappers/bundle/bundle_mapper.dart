import '../../../domain/entities/bundle/bundle.dart';
import '../../../domain/entities/category/category.dart';
import '../../../domain/entities/discount/discount.dart';
import '../../../domain/entities/product/product.dart';
import '../../../domain/entities/bundle/bundle_product.dart';

class BundleMapper {
  // Single bundle mapping
  static Bundle fromJson(Map<String, dynamic> json) {
    return _parseBundle(json);
  }

  // Multiple bundles mapping
  static List<Bundle> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => _parseBundle(json)).toList();
  }

  // Internal parsing method
  static Bundle _parseBundle(Map<String, dynamic> json) {
    try {
      return Bundle(
        id: json['id'] as String? ?? '',
        name: json['name'] as String? ?? 'Sin nombre',
        description: json['description'] as String? ?? 'Descripción no disponible',
        currency: json['currency'] as String? ?? 'USD',
        price: (json['price'] as num?)?.toDouble() ?? 0.0,
        stock: json['stock'] as int? ?? 0,
        weight: (json['weight'] as num?)?.toDouble() ?? 0.0,
        measurement: json['measurement'] as String? ?? '',

        // Image handling
        imageUrl: _parseImageUrl(json['images']),

        // Caducity date handling
        caducityDate: _parseCaducityDate(json['caducityDate']),

        // Products handling
        products: _parseProducts(json['product']),

        // Categories handling
        categories: _parseCategories(json['category']),

        // Discounts handling
        discounts: _parseDiscounts(json['discount']),
      );
    } catch (e) {
      print('Error parsing bundle: $e');
      rethrow;
    }
  }

  // Utility parsing methods
  static String _parseImageUrl(dynamic images) {
    if (images is List && images.isNotEmpty) {
      return images.first ?? 'https://via.placeholder.com/150';
    }
    return 'https://via.placeholder.com/150';
  }

  static DateTime _parseCaducityDate(dynamic caducityDate) {
    if (caducityDate is String) {
      try {
        return DateTime.parse(caducityDate);
      } catch (e) {
        print('Error parsing caducity date: $e');
      }
    }
    return DateTime.now().add(Duration(days: 365)); // Default to 1 year from now
  }

  static List<BundleProduct> _parseProducts(dynamic productData) {
    if (productData is List) {
      return productData.map((productJson) {
        return BundleProduct(
          id: productJson['id'] as String? ?? '',
          name: productJson['name'] as String? ?? '',
          description: productJson['description'] as String?,
          price: (productJson['price'] as num?)?.toDouble() ?? 0.0,
          weight: (productJson['weight'] as num?)?.toDouble() ?? 0.0,
          quantity: productJson['quantity'] as int? ?? 0,
          measurement: productJson['measurement'] as String?,
          imageUrl: _parseImageUrl(productJson['images']),
        );
      }).toList();
    }
    return [];
  }

  static List<Category> _parseCategories(dynamic categoryData) {
    if (categoryData is List) {
      return categoryData.map((categoryJson) => Category(
        id: categoryJson['id'] as String? ?? '',
        name: categoryJson['name'] as String? ?? '',
        imageUrl: '',
      )).toList();
    }
    return [];
  }

  static List<Discount> _parseDiscounts(dynamic discountData) {
    if (discountData is List) {
      return discountData.map((discountJson) => Discount(
        id: discountJson['id'] as String? ?? '',
        percentage: (discountJson['percentage'] as num?)?.toDouble() ?? 0.0,
      )).toList();
    }
    return [];
  }

  // Conversion to JSON
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
      'images': [bundle.imageUrl],
      'caducityDate': bundle.caducityDate.toIso8601String(),
      'product': bundle.products.map((product) => {
        'id': product.id,
        'name': product.name,
        'description': product.description,
        'price': product.price,
        'weight': product.weight,
        'quantity': product.quantity,
        'measurement': product.measurement,
        'images': [product.imageUrl]
      }).toList(),
      'category': bundle.categories.map((category) => {
        'id': category.id,
        'name': category.name
      }).toList(),
      'discount': bundle.discounts.map((discount) => {
        'id': discount.id,
        'percentage': discount.percentage
      }).toList(),
    };
  }
}