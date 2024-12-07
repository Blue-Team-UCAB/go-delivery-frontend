//import 'package:go_delivery_frontend/domain/entities/category/category.dart';

class Product {
  final String id;
  final String name;
  final double price;
  final double weight;
  final String measurement;
  final String description;
  final List<String> categories;
  String imageUrl;
  final String currency;
  final int stock;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.weight,
    required this.measurement,
    required this.description,
    required this.categories,
    required this.imageUrl,
    required this.currency,
    required this.stock,
  });
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

class CheckoutProduct{
  final String id;
  final int quantity;

  const CheckoutProduct({
    required this.id,
    required this.quantity,
  });
}
