import 'package:go_delivery_frontend/domain/entities/category/category.dart';

class Product {
  final String id;
  final String name;
  final double price;
  final double weight;
  final String description;
  final Category category;
  String imageUrl;
  final String currency;
  final int stock;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.weight,
    required this.description,
    required this.category,
    required this.imageUrl,
    required this.currency,
    required this.stock,
  });
}
