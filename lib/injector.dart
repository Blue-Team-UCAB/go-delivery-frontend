import 'package:get_it/get_it.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_delivery_frontend/application/BLoc/blocs.dart';
import 'package:go_delivery_frontend/application/BLoc/product/product_many/product_many_bloc.dart';
import 'package:go_delivery_frontend/application/use_cases/auth/register/register_usecase_input.dart';
import 'package:go_delivery_frontend/infrastructure/datasources/api/api_request_impl.dart';
import 'package:go_delivery_frontend/infrastructure/datasources/localstorage/localstorage_impl.dart';
import 'package:go_delivery_frontend/domain/repositories/product/product_repository.dart';
import 'package:go_delivery_frontend/infrastructure/repositories/product/product_repository_impl.dart';
import 'package:go_delivery_frontend/application/use_cases/product/get_many_product.dart';

import 'application/BLoc/auth/login/login_bloc.dart';
import 'application/BLoc/auth/recover_password/recover_password_bloc.dart';
import 'application/BLoc/auth/register/register_bloc.dart';
import 'application/BLoc/cart/cart_bloc.dart';
import 'application/BLoc/themes/themes_bloc.dart';
import 'application/use_cases/auth/login/login_usecase_input.dart';
import 'infrastructure/repositories/user/user_repository_impl.dart';

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

    final userRepository = UserRepositoryImpl(
        apiRequestManager: apiRequestManagerImpl,
        localStorage: localStorageService);

    //caso de uso
    final loginUseCase = LoginUseCase(userRepository: userRepository);
    final registerUseCase = RegisterUseCase(userRepository: userRepository);

    // Registrar
    getIt.registerFactory(() => LoginBloc(loginUseCase: loginUseCase));
    getIt.registerFactory(() => RegisterBloc(userRepository.register));
    getIt.registerSingleton(
        RecoverPasswordBloc(userRespository: userRepository));

    //final recoveryUseCase

    //registrar caso de uso
    getIt.registerSingleton<LoginUseCase>(loginUseCase);
    getIt.registerSingleton<RegisterUseCase>(registerUseCase);
    // ======================================================================= //

    // ============================= CART ==================================== //
    getIt.registerSingleton(CartBloc());
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

    // BLOC del Carrito
    getIt.registerSingleton(ProductListBloc(getProductsUseCase));
  }
}
