import 'package:get_it/get_it.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_delivery_frontend/infrastructure/datasources/api/api_request_impl.dart';
import 'package:go_delivery_frontend/infrastructure/datasources/localstorage/localstorage_impl.dart';
import 'package:go_delivery_frontend/domain/repositories/product/product_repository.dart';
import 'package:go_delivery_frontend/infrastructure/repositories/product/product_repository_impl.dart';
import 'package:go_delivery_frontend/application/use_cases/product/get_many_product.dart';

import 'application/BLoc/themes/themes_bloc.dart';

final getIt = GetIt.instance;

class InjectManager {
  static Future<void> setUpInjections() async {
    await dotenv.load(fileName: ".env");
    final LocalStorageService localStorageService = LocalStorageService();
    final apiRequestManagerImpl = ApiRequestManagerImpl(
      baseDirection: dotenv.env['API_URL']!,
    );

    // ============================= THEME =================================== //
    getIt.registerSingleton(ThemesBloc());
    // ======================================================================= //


    // ============================= AUTH ==================================== //
    /*
    final userRepositoryImpl = UserRepositoryImpl(
        userDatasource: apiUserDatasource,
        keyValueStorage: localStorageService);

    // Registrar el repositorio de usuarios
    getIt.registerFactory(() =>
        RegisterBloc(userRepositoryImpl.register));
    getIt.registerFactory(() =>
        LoginBloc(userRespository: userRepositoryImpl));
    getIt.registerSingleton(
        RecoverPasswordBloc(userRespository: userRepositoryImpl));

    */
    // ======================================================================= //


    // ============================= NOTIFICATIONS =========================== //
    /*
    final notificationsRepositoryImpl = NotificationRespositoryImpl(
            notificationsDatasource:
            NotificationsDatasourceImpl(localStorageService));

    getIt.registerFactory(() =>
        NotificationListBloc(notificationsRepository: notificationsRepositoryImpl));

    getIt.registerSingleton(NotificationsBloc(
        FirebaseNotificationsManager(LocalNotifications()),
        notificationsRepositoryImpl.saveToken));
     */
    // ======================================================================= //


    // ============================= PRODUCTS ============================= //
    // Repositorio
    final productRepository = ProductRepositoryImpl(
      apiRequestManager: apiRequestManagerImpl,
      localStorage: localStorageService,
    );
    // Registrar el repositorio de productos
    getIt.registerSingleton<ProductRepository>(productRepository);
    // Casos de Uso
    final getProductsUseCase = GetProductsUseCase(
      productRepository: productRepository,
    );
    // Registrar el caso de uso de obtención de productos
    getIt.registerSingleton<GetProductsUseCase>(getProductsUseCase);
    // ======================================================================= //
  }
}
