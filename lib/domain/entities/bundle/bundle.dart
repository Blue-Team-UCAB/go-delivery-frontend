import '../category/category.dart';
import '../discount/discount.dart';
import 'bundle_product.dart';

class Bundle {
  final String id;
  final String name;
  final String description;
  final String currency;
  final double price;
  final int stock;
  final double weight;
  final String measurement;
  final String imageUrl;
  final DateTime caducityDate;
  final List<BundleProduct> products;
  final List<Category> categories;
  final List<Discount> discounts;

  Bundle({
    required this.id,
    required this.name,
    required this.description,
    required this.currency,
    required this.price,
    required this.stock,
    required this.weight,
    required this.measurement,
    required this.imageUrl,
    required this.caducityDate,
    required this.products,
    required this.categories,
    required this.discounts,
  });
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
