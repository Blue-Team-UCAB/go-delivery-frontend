
import '../../../common/result.dart';
import '../../../common/use_cases.dart';
import '../../../domain/entities/category/category.dart';
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

  @override
  Future<Result<Order>> execute(GetOneOrderUseCaseInput input) async {

    await Future.delayed(Duration(seconds: 1));

    //_orderRepository.getOrderById(input.orderId);

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
          category: Category(id: 'cat1', name: 'Smartphones', icon: '📱'),
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
          category: Category(id: 'cat2', name: 'Laptops', icon: '💻'),
          imageUrl: 'https://example.com/macbookair.jpg',
        ),
        Product(
          id: '3',
          name: 'AirPods Pro',
          description: 'With MagSafe Charging Case',
          currency: 'USD',
          price: 249.00,
          weight: 0.055,
          stock: 100,
          category: Category(id: 'cat3', name: 'Audio', icon: '🎧'),
          imageUrl: 'https://example.com/airpodspro.jpg',
        ),
        Product(
          id: '4',
          name: 'Apple Watch Series 7',
          description: 'GPS, 45mm Aluminum Case, Midnight Sport Band',
          currency: 'USD',
          price: 399.00,
          weight: 0.032,
          stock: 75,
          category: Category(id: 'cat4', name: 'Wearables', icon: '⌚'),
          imageUrl: 'https://example.com/applewatch7.jpg',
        ),
        Product(
          id: '5',
          name: 'iPad Air',
          description: '64GB, Wi-Fi, Space Gray',
          currency: 'USD',
          price: 599.00,
          weight: 0.46,
          stock: 60,
          category: Category(id: 'cat5', name: 'Tablets', icon: '📱'),
          imageUrl: 'https://example.com/ipadair.jpg',
        ),
      ],
    );

    var r = Result.success(o);
    return r;
  }
}