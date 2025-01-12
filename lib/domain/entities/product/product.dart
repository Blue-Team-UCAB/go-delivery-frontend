import 'package:go_delivery_frontend/domain/entities/category/category.dart';
import 'package:go_delivery_frontend/domain/entities/discount/discount.dart';

class Product {
  String id;
  String name;
  String description;
  String currency;
  double price;
  int stock;
  double weight;
  String measurement;
  String? imageUrl;
  List<String> images;
  List<Category> categories;
  List<Discount> discounts;
  DateTime caducityDate;

  Product({
    this.id = '',
    required this.name,
    required this.description,
    required this.currency,
    required this.price,
    required this.stock,
    required this.weight,
    required this.measurement,
    this.imageUrl,
    required this.images,
    this.categories = const [],
    this.discounts = const [],
    DateTime? caducityDate,
  }) : caducityDate = caducityDate ?? DateTime.now().add(Duration(days: 365));
}

class OrderProduct {
  final String id;
  final String name;
  final double price;
  final int quantity;
  final String imageUrl;

  const OrderProduct({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    required this.imageUrl,
  });
}

class CheckoutProduct {
  final String id;
  final int quantity;

  const CheckoutProduct({
    required this.id,
    required this.quantity,
  });
}
