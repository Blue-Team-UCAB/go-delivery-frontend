import 'package:go_delivery_frontend/domain/entities/product/product.dart';

class Bundle {
  String id;
  String name;
  String description;
  String currency;
  double price;
  int stock;
  double weight;
  String imageUrl;
  DateTime caducityDate;
  List<Product> products;

  Bundle({
    required this.id,
    required this.name,
    required this.description,
    required this.currency,
    required this.price,
    required this.stock,
    required this.weight,
    required this.imageUrl,
    required this.caducityDate,
    required this.products,
  });
}
