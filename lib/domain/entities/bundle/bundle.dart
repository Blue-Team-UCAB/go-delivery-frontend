import '../category/category.dart';
import '../discount/discount.dart';
import 'bundle_product.dart';

class Bundle {
  final String id;
  final String name;
  final String description;
  final String currency;
  final double price;
  final int? stock;
  final double? weight;
  final String? measurement;
  final List<String> images;
  final DateTime? caducityDate;
  final List<BundleProduct>? products;
  final List<Category>? categories;
  final List<Discount>? discounts;

  const Bundle({
    required this.id,
    required this.name,
    required this.description,
    required this.currency,
    required this.price,
    this.stock,
    this.weight,
    this.measurement,
    required this.images,
    this.caducityDate,
    this.products,
    this.categories,
    this.discounts,
  });

  Bundle copyWith({
    String? id,
    String? name,
    String? description,
    String? currency,
    double? price,
    int? stock,
    double? weight,
    String? measurement,
    List<String>? images,
    DateTime? caducityDate,
    List<BundleProduct>? products,
    List<Category>? categories,
    List<Discount>? discounts,
  }) {
    return Bundle(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      currency: currency ?? this.currency,
      price: price ?? this.price,
      stock: stock ?? this.stock,
      weight: weight ?? this.weight,
      measurement: measurement ?? this.measurement,
      images: images ?? this.images,
      caducityDate: caducityDate ?? this.caducityDate,
      products: products ?? this.products,
      categories: categories ?? this.categories,
      discounts: discounts ?? this.discounts,
    );
  }
}

class OrderBundle {
  final String id;
  final String name;
  final double price;
  final int quantity;
  final String imageUrl;

  const OrderBundle({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    required this.imageUrl,
  });
}

class CheckoutBundle {
  final String id;
  final int quantity;

  const CheckoutBundle({
    required this.id,
    required this.quantity,
  });
}
