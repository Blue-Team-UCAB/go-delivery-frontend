import '../product/product.dart';

class Order{
  final String orderNumber;
  final String date;
  final String items;
  final String price;
  final String status;
  final String time;
  final String location;
  final List<Product> products;

  Order({
    required this.orderNumber,
    required this.date,
    required this.items,
    required this.price,
    required this.status,
    required this.time,
    required this.location,
    required List<Product> this.products
  });
}
