
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
  List<dynamic> products;

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
