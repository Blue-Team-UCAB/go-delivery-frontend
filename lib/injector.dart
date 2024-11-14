import 'package:get_it/get_it.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_delivery_frontend/application/BLoc/blocs.dart';
import 'package:go_delivery_frontend/application/BLoc/product/product_many/product_many_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_delivery_frontend/infraestructure/datasources/api/api_request_impl.dart';
import 'package:go_delivery_frontend/infraestructure/datasources/localstorage/localstorage_impl.dart';
import 'package:go_delivery_frontend/domain/repositories/product/product_repository.dart';
import 'package:go_delivery_frontend/infraestructure/repositories/product/product_repository_impl.dart';
import 'package:go_delivery_frontend/application/use_cases/product/get_many_product.dart';

class InjectManager {
  static Future<void> setUpInjections() async {
    final getIt = GetIt.instance;
    await dotenv.load(fileName: ".env");
    final sharedPreferences = await SharedPreferences.getInstance();
    final localStorage = LocalStorageImpl(prefs: sharedPreferences);
    final apiRequestManagerImpl = ApiRequestManagerImpl(
      baseUrl: dotenv.env['API_URL']!,
    );
    apiRequestManagerImpl.setHeaders('Authorization',
        'bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjllYTZmMmUwLWIxYTAtNGYzMC05MTMyLTNjMWZjYTU0NTViOCIsImlhdCI6MTczMTQ2NjcyNCwiZXhwIjoxNzMxNTUzMTI0fQ.g08wRaHlxr0IGoz57eh-wviWz1iv03D-y_vTy6nNyi8');

    // Repositorios

    final productRepository = ProductRepositoryImpl(
      apiRequestManager: apiRequestManagerImpl,
      localStorage: localStorage,
    );

    // Registrar el repositorio de productos
    getIt.registerSingleton<ProductRepository>(productRepository);

    // Casos de Uso
    final getProductsUseCase = GetProductsUseCase(
      productRepository: productRepository,
    );

    // Registrar el caso de uso de obtención de productos
    getIt.registerSingleton<GetProductsUseCase>(getProductsUseCase);

    // BLOC del Carrito
    getIt.registerSingleton(CartBloc());
    getIt.registerSingleton(ProductListBloc(getProductsUseCase));
  }
}
