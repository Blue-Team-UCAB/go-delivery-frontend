import 'package:go_delivery_frontend/infrastructure/models/order_many_model.dart';

import '../../../../domain/entities/order/order.dart';

abstract class ManyOrdersState {}

class ManyOrdersInitialState extends ManyOrdersState {}

class ManyOrdersLoadingState extends ManyOrdersState {}

class ManyOrdersLoadedState extends ManyOrdersState {
  final List<OrderManyItem> orders;
  final int page;
  final int perpage;
  final String status;

  ManyOrdersLoadedState({
    required this.orders,
    required this.page,
    required this.perpage,
    required this.status
  });
}

class ManyOrdersErrorState extends ManyOrdersState {
  final String error;

  ManyOrdersErrorState({required this.error});
}