import 'package:go_delivery_frontend/infrastructure/mappers/courier/courier_mapper.dart';
import 'package:go_delivery_frontend/infrastructure/mappers/product/orderproduct_mapper.dart';

import 'package:go_delivery_frontend/domain/entities/order/order.dart';
import 'package:go_delivery_frontend/infrastructure/mappers/order/many/many_orderbundle_mapper.dart';

import 'package:go_delivery_frontend/infrastructure/mappers/direction/direction_order_mapper.dart';

class OrderMapper {
  static Order fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['orderId'],
      state: (json['orderState'] as List)
          .map((stateJson) => OrderStateMapper.fromJson(stateJson))
          .toList(),
      totalAmount: json['totalAmount'].toDouble(),
      subtotalAmount: json['subTotal'].toDouble(),
      orderReceivedDate: json.containsKey('orderReceivedDate')
          ? DateTime.parse(json['orderReceivedDate'])
          : null,
      orderTimeCreated: json['orderTimeCreated'],
      direction: DirectionOrderMapper.fromJson(json['orderDirection']),
      courier: json['orderCourier'] != null
          ? CourierMapper.fromJson(json['orderCourier'])
          : null,
      products: (json['products'] as List)
          .map((productJson) => OrderProductMapper.fromJson(productJson))
          .toList(),
      bundles: (json['bundles'] as List)
          .map((bundleJson) => OrderBundleMapper.fromJson(bundleJson))
          .toList(),
      orderPayment: OrderPaymentMapper.fromJson(json['orderPayment']),
    );
  }

  static Map<String, dynamic> toJson(Order order) {
    return {
      'orderId': order.id,
      'orderState': order.state.map((s) => OrderStateMapper.toJson(s)).toList(),
      'totalAmount': order.totalAmount,
      'subTotal': order.subtotalAmount,
      'orderReceivedDate': order.orderReceivedDate?.toIso8601String(),
      'orderTimeCreated': order.orderTimeCreated,
      'orderDirection': DirectionOrderMapper.toJson(order.direction),
      'orderCourier': order.courier != null
          ? CourierMapper.toJson(order.courier!)
          : null,
      'products': order.products.map((p) => OrderProductMapper.toJson(p)).toList(),
      'bundles': order.bundles.map((b) => OrderBundleMapper.toJson(b)).toList(),
      'orderPayment': OrderPaymentMapper.toJson(order.orderPayment),
    };
  }
}

// You'll need to create additional mappers for the new fields
class OrderPaymentMapper {
  static OrderPayment fromJson(Map<String, dynamic> json) {
    return OrderPayment(
      paymentAmount: json['paymetAmount'].toDouble(), // Note: typo in original JSON
      paymentCurrency: json['paymentCurrency'],
      paymentMethod: json['paymentMethod'],
    );
  }

  static Map<String, dynamic> toJson(OrderPayment payment) {
    return {
      'paymetAmount': payment.paymentAmount,
      'paymentCurrency': payment.paymentCurrency,
      'paymentMethod': payment.paymentMethod,
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
