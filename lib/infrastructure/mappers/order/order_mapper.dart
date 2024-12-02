import '../../../domain/entities/order/order.dart';
import '../product/product_mapper.dart';

class OrderMapper {
  static Order fromJson(Map<String, dynamic> json) {
    return Order(
      orderNumber: json['orderNumber'] ?? '',
      date: json['date'] ?? '',
      items: json['items'] ?? '',
      price: json['price'] ?? '',
      status: json['status'] ?? '',
      time: json['time'] ?? '',
      location: json['location'] ?? '',
      products: (json['products'] as List<dynamic>?)
          ?.map((productJson) => ProductMapper.fromJson(productJson))
          .toList() ?? [],
    );
  }

  static Map<String, dynamic> toJson(Order order) {
    return {
      'orderNumber': order.orderNumber,
      'date': order.date,
      'items': order.items,
      'price': order.price,
      'status': order.status,
      'time': order.time,
      'location': order.location,
      'products': order.products.map((product) => ProductMapper.toJson(product)).toList(),
    };
  }
}