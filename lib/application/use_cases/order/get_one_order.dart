import '../../../common/result.dart';
import '../../../common/use_cases.dart';
//import '../../../domain/entities/category/category.dart';
import '../../../domain/entities/order/order.dart';
import '../../../domain/entities/product/product.dart';
import '../../../domain/repositories/order/order_repository.dart';

class GetOneOrderUseCaseInput extends IUseCaseInput {
  final String orderId;

  GetOneOrderUseCaseInput({required this.orderId});
}

class GetOneOrderUseCase {
  final OrderRepository _orderRepository;

  GetOneOrderUseCase({required OrderRepository orderRepository})
      : _orderRepository = orderRepository;

  Future<Result<Order>> execute(GetOneOrderUseCaseInput input) async {
    await Future.delayed(const Duration(seconds: 1));

    var o = Order(
      orderNumber: '123334',
      date: '2023-11-29',
      items: 'Smartphone\nLaptop\nWireless Earbuds\nSmartwatch\nTablet',
      price: '\$2,499.95',
      status: 'Por Entregar',
      time: 'Efectuado a las 3:27 pm',
      location: 'Edif. El Turpial, El Paraiso, Caracas, Venezuela',
      products: [
        Product(
          id: '1',
          name: 'iPhone 13 Pro',
          description: '256GB, Graphite',
          currency: 'USD',
          price: 999.99,
          weight: 0.24,
          stock: 50,
          categories: [
            // Cambiado para aceptar lista de cadenas
            'Smartphones'
          ],
          imageUrl: 'https://example.com/iphone13pro.jpg',
        ),
        Product(
          id: '2',
          name: 'MacBook Air M1',
          description: '13-inch, 8GB RAM, 256GB SSD, Space Gray',
          currency: 'USD',
          price: 999.00,
          weight: 1.29,
          stock: 30,
          categories: ['Laptops'],
          imageUrl: 'https://example.com/macbookair.jpg',
        ),
        // Resto de los productos...
      ],
    );

    var r = Result.success(o);
    return r;
  }
}
