import 'package:go_delivery_frontend/domain/entities/bundle/bundle.dart';
import 'package:go_delivery_frontend/domain/entities/product/product.dart';
import 'package:go_delivery_frontend/infrastructure/mappers/product/product_mapper.dart';

class BundleMapper {
  static Bundle fromJson(Map<String, dynamic> json) {
    try {
      List<Product> products = (json['products'] as List?)
              ?.map((productData) => ProductMapper.fromJson(productData))
              .toList() ??
          [];

      return Bundle(
        id: json['id'] as String? ?? '',
        name: json['name'] as String? ?? 'Sin nombre',
        description:
            json['description'] as String? ?? 'Descripción no disponible',
        currency: json['currency'] as String? ?? 'USD',
        price: (json['price'] as num?)?.toDouble() ?? 0.0,
        stock: json['stock'] as int? ?? 0,
        weight: (json['weight'] as num?)?.toDouble() ?? 0.0,
        imageUrl: json['imageUrl'] as String? ?? '',
        caducityDate: json['caducityDate'] != null
            ? DateTime.parse(json['caducityDate'] as String)
            : DateTime.now(),
        products: products,
      );
    } catch (e) {
      print('Error in BundleMapper.fromJson: $e');
      rethrow;
    }
  }

  static Map<String, dynamic> toJson(Bundle bundle) {
    return {
      'id': bundle.id,
      'name': bundle.name,
      'description': bundle.description,
      'currency': bundle.currency,
      'price': bundle.price,
      'stock': bundle.stock,
      'weight': bundle.weight,
      'imageUrl': bundle.imageUrl,
      'caducityDate': bundle.caducityDate.toIso8601String(),
      'products': bundle.products.map((p) => ProductMapper.toJson(p)).toList(),
    };
  }
}
