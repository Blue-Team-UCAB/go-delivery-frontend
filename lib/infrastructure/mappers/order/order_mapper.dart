import 'package:go_delivery_frontend/infrastructure/mappers/product/orderproduct_mapper.dart';

import '../../../domain/entities/order/order.dart';
import '../bundle/bundle_mapper.dart';
import '../direction/direction_mapper.dart';
import 'many/many_orderbundle_mapper.dart';

class OrderMapper {
  static Order fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      state: (json['state'] as List)
          .map((stateJson) => OrderStateMapper.fromJson(stateJson))
          .toList(),
      totalAmount: json['totalAmount'].toDouble(),
      subtotalAmount: json['subtotalAmount'].toDouble(),
      direction: DirectionMapper.fromJson(json['direction']),
      products: (json['products'] as List)
          .map((productJson) => OrderProductMapper.fromJson(productJson))
          .toList(),
      bundles: (json['bundles'] as List)
          .map((bundleJson) => OrderBundleMapper.fromJson(bundleJson))
          .toList(),
    );
  }

  static Map<String, dynamic> toJson(Order order) {
    return {
      'id': order.id,
      'state': order.state.map((s) => OrderStateMapper.toJson(s)).toList(),
      'totalAmount': order.totalAmount,
      'subtotalAmount': order.subtotalAmount,
      'direction': DirectionMapper.toJson(order.direction),
      'products': order.products.map((p) => OrderProductMapper.toJson(p)).toList(),
      'bundles': order.bundles.map((b) => OrderBundleMapper.toJson(b)).toList(),
    };
  }
}

class OrderStateMapper {
  static OrderState fromJson(Map<String, dynamic> json) {
    return OrderState(
      state: json['state'],
      date: json['date'],
    );
  }

  static Map<String, dynamic> toJson(OrderState state) {
    return {
      'state': state.state,
      'date': state.date,
    };
  }
}

