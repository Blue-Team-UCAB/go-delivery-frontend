import 'package:go_delivery_frontend/infrastructure/mappers/courier/courier_mapper.dart';
import 'package:go_delivery_frontend/infrastructure/mappers/product/orderproduct_mapper.dart';

import 'package:go_delivery_frontend/domain/entities/order/order.dart';
import 'package:go_delivery_frontend/infrastructure/mappers/order/many/many_orderbundle_mapper.dart';

import 'package:go_delivery_frontend/infrastructure/mappers/direction/direction_order_mapper.dart';
import 'package:intl/intl.dart';

import '../../../domain/entities/bundle/bundle.dart';
import '../../../domain/entities/direction/direction.dart';
import '../../../domain/entities/product/product.dart';

class OrderMapper {
  static Order fromJson(Map<String, dynamic> json) {

    print('Query Parameters:');
    json.forEach((key, value) {
      print('  - $key: $value');
    });

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


class OrderCreationMapper {
  static Order fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] ?? '',
      state: _parseOrderStates(json['orderState']),
      orderTimeCreated: json['orderCreatedDate'],
      totalAmount: _parseDouble(json['totalAmount']),
      subtotalAmount: _parseDouble(json['subtotalAmount']),
      direction: _parseDirection(json['orderDirection']),
      products: _parseProducts(json['products']),
      bundles: _parseBundles(json['bundles']),
      orderPayment: _parseOrderPayment(json['orderPayment']),
    );
  }

  static List<OrderState> _parseOrderStates(dynamic orderStates) {
    print("STATE PARSING");
    if (orderStates == null || orderStates is! List) return [];
    return orderStates.map((state) => OrderStateMapper.fromJson(state)).toList();
  }

  static double _parseDouble(dynamic value) {
    print("DOUBLE PARSING");
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  static DirectionOrder _parseDirection(dynamic direction) {
    print("DIRECTION PARSING");
    if (direction == null || direction is! Map<String, dynamic>) {
      return DirectionOrder(latitude: 0, longitude: 0);
    }
    return DirectionOrderMapper.fromJson(direction);
  }

  static List<OrderProduct> _parseProducts(dynamic products) {
    print("STARTING PRODUCT PARSING");
    if (products == null || products is! List) return [];
    return products.map((product) => OrderProductMapper.fromJson(product)).toList();
  }

  static List<OrderBundle> _parseBundles(dynamic bundles) {
    print("STARTING BUNDLE PARSING");
    if (bundles == null || bundles is! List) return [];
    return bundles.map((bundle) => OrderBundleMapper.fromJson(bundle)).toList();
  }

  static OrderPayment _parseOrderPayment(dynamic payment) {
    print("STARTING ORDERPAYMENT PARSING");
    if (payment == null || payment is! Map<String, dynamic>) {
      return OrderPayment(paymentAmount: 0, paymentCurrency: '', paymentMethod: '');
    }
    return OrderCreationPaymentMapper.fromJson(payment);
  }

  static Map<String, dynamic> toJson(Order order) {
    return {
      'id': order.id,
      'orderState': order.state.map((s) => OrderStateMapper.toJson(s)).toList(),
      'orderCreatedDate': order.orderTimeCreated.toString(),
      'orderTimeCreated': DateFormat('h:mm:ss a').format(order.orderTimeCreated as DateTime),
      'totalAmount': order.totalAmount,
      'subtotalAmount': order.subtotalAmount,
      'currency': order.orderPayment.paymentCurrency,
      'orderDirection': DirectionOrderMapper.toJson(order.direction),
      'products': order.products.map((p) => OrderProductMapper.toJson(p)).toList(),
      'bundles': order.bundles.map((b) => OrderBundleMapper.toJson(b)).toList(),
      'orderPayment': OrderCreationPaymentMapper.toJson(order.orderPayment),
    };
  }
}


class OrderPaymentMapper {
  static OrderPayment fromJson(Map<String, dynamic> json) {
    return OrderPayment(
      paymentAmount: json['paymetAmount'].toDouble(),
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


class OrderCreationPaymentMapper {
  static OrderPayment fromJson(Map<String, dynamic> json) {
    return OrderPayment(
      paymentAmount: json['amount'].toDouble(),
      paymentCurrency: json['currency'],
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
