import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../domain/entities/bundle/bundle.dart';
import '../../../../domain/entities/direction/direction.dart';
import '../../../../domain/entities/order/order.dart';
import '../../../../domain/entities/product/product.dart';

abstract class OrderDetailState {}

class OrderDetailInitialState extends OrderDetailState {}

class OrderDetailLoadingState extends OrderDetailState {}

class OrderDetailLoadedState extends OrderDetailState {
  final String id;
  final List<OrderState> state;
  final double totalAmount;
  final double subtotalAmount;
  final Direction direction;
  final List<OrderProduct> products;
  final List<OrderBundle> bundles;

  OrderDetailLoadedState({
    required this.id,
    required this.state,
    required this.totalAmount,
    required this.subtotalAmount,
    required this.direction,
    required this.products,
    required this.bundles,
  });

  String get orderNumber => id;
  String get date => state.isNotEmpty ? state.first.date : '';
  String get time => state.isNotEmpty ? state.first.date.split(' ')[1] : '';
  String get location => direction.direction;
  String get price => totalAmount.toString();
  String get last_state => state.isNotEmpty ? state.last.state : '';
  LatLng get coordinates => LatLng(direction.latitude,direction.longitude);
}

class OrderDetailErrorState extends OrderDetailState {
  final String error;

  OrderDetailErrorState({required this.error});
}