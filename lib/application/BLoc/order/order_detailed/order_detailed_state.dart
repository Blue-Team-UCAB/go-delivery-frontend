import '../../../../domain/entities/product/product.dart';

abstract class OrderDetailState {}

class OrderDetailInitialState extends OrderDetailState {}

class OrderDetailLoadingState extends OrderDetailState {}

class OrderDetailLoadedState extends OrderDetailState {
  final String orderNumber;
  final String date;
  final String time;
  final String location;
  final String price;
  final String status;
  final List<Product> products;

  OrderDetailLoadedState({
    required this.orderNumber,
    required this.date,
    required this.time,
    required this.location,
    required this.price,
    required this.status,
    required this.products,
  });
}

class OrderDetailErrorState extends OrderDetailState {
  final String error;

  OrderDetailErrorState({required this.error});
}