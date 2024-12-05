import 'package:get_it/get_it.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_delivery_frontend/application/BLoc/blocs.dart'; //Para añadir nuevos blocs
import 'package:go_delivery_frontend/application/use_cases/use_cases.dart'; //Para añadir nuevos casos de uso
import 'package:go_delivery_frontend/domain/repositories/repositories_interface.dart'; //Para añadir las interfaces de los repositorios
import 'package:go_delivery_frontend/infrastructure/repositories/repositories.dart'; //Para añadir las implementaciones de los repositorios
import 'package:go_delivery_frontend/infrastructure/datasources/api/api_request_impl.dart';
import 'package:go_delivery_frontend/infrastructure/datasources/cart/cart_isar_local_storage_datasource.dart';
import 'package:go_delivery_frontend/infrastructure/datasources/localstorage/localstorage_impl.dart';
import 'application/BLoc/auth/recover_password/recover_password_bloc.dart';
import 'application/BLoc/auth/register/register_bloc.dart';
import 'application/use_cases/order/get_one_order.dart';

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
    final recoveryUseCase = RecoveryUseCase(userRepository: userRepository);
    final getCurrentUseCase =
        CurrentUserUseCase(userRepository: userRepository);

    // Registrar
    getIt.registerFactory(() => LoginBloc(loginUseCase: loginUseCase));
    getIt.registerFactory(() => RegisterBloc(userRepository.register));
    getIt.registerSingleton(
        RecoverPasswordBloc(recoveryUseCase: recoveryUseCase));
    getIt.registerSingleton(
        CurrentUserBloc(currentUserUseCase: getCurrentUseCase));

    //registrar caso de uso
    getIt.registerSingleton<LoginUseCase>(loginUseCase);
    getIt.registerSingleton<RegisterUseCase>(registerUseCase);
    getIt.registerSingleton<RecoveryUseCase>(recoveryUseCase);
    getIt.registerSingleton<CurrentUserUseCase>(getCurrentUseCase);
    // ======================================================================= //

    // ============================= CART ==================================== //
    final cartLocalStorageRepo =
        CartLocalStorageRepositoryImpl(CartIsarLocalStorageDatasource());
    getIt.registerSingleton(CartBloc(cartLocalStorageRepo));
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
    final getProductsUseCase =
        GetProductsUseCase(productRepository: productRepository);
    final getOneProductUseCase =
        GetOneProductUseCase(productRepository: productRepository);

    // Registrar el caso de uso de obtención de productos
    getIt.registerSingleton<GetProductsUseCase>(getProductsUseCase);
    getIt.registerSingleton<GetOneProductUseCase>(getOneProductUseCase);
    // ======================================================================= //

    // BLOC del Carrito
    getIt.registerSingleton(ProductListBloc(getProductsUseCase));
    getIt.registerSingleton(ProductDetailBloc(getOneProductUseCase));

    // Popular List
    getIt.registerSingleton(ProductPopularListBloc(getProductsUseCase));

    // Random List
    //THIS IS A PLACEHOLDER. Pronto estará el Popular list definitivo despues de tener casi listo la app
    getIt.registerSingleton(ProductRandomListBloc(getProductsUseCase));

    // ============================= BUNDLES ============================= //
    // Repositorio
    final bundleRepository = BundleRepositoryImpl(
      apiRequestManager: apiRequestManagerImpl,
      localStorage: localStorageService,
    );

    // Registrar el repositorio de bundles
    getIt.registerSingleton<BundleRepository>(bundleRepository);

    // Casos de Uso
    final getBundlesUseCase =
        GetBundlesUseCase(bundleRepository: bundleRepository);
    final getOneBundleUseCase =
        GetOneBundleUseCase(bundleRepository: bundleRepository);

    // Registrar el caso de uso de obtención de bundles
    getIt.registerSingleton<GetBundlesUseCase>(getBundlesUseCase);
    getIt.registerSingleton<GetOneBundleUseCase>(getOneBundleUseCase);
    // ======================================================================= //

    // BLOC del Carrito
    getIt.registerSingleton(BundleListBloc(getBundlesUseCase));
    getIt.registerSingleton(BundleDetailBloc(getOneBundleUseCase));

    // ============================= ORDER =================================== //
    //Repositorio
    final orderRepository = OrderRepositoryImpl(
        apiRequestManager: apiRequestManagerImpl,
        localStorage: localStorageService);

    // Registrar el repositorio de ordenes
    getIt.registerSingleton<OrderRepository>(orderRepository);

    //casos de uso
    final getOneOrderUseCase =
        GetOneOrderUseCase(orderRepository: orderRepository);

    getIt.registerSingleton<GetOneOrderUseCase>(getOneOrderUseCase);
    // ======================================================================= //

    getIt.registerSingleton(
        OrderDetailBloc(getOneOrderUseCase: getOneOrderUseCase));

    // ============================= PAYMENT =================================== //

    //Repositorio
    final paymentRepository = PaymentRepositoryImpl(
        apiRequestManager: apiRequestManagerImpl,
        localStorage: localStorageService);

    // Registrar el repositorio de payment
    getIt.registerSingleton<PaymentRepository>(paymentRepository);

    // ============================= PAGO MOVIL =================================== //

    //Casos de uso
    final processPagoMovilUseCase =
        ProcessPagoMovilUseCase(paymentRepository: paymentRepository);

    getIt.registerSingleton<ProcessPagoMovilUseCase>(processPagoMovilUseCase);

    //Bloc
    getIt.registerSingleton(PaymentBloc(processPagoMovilUseCase));

    // ============================= ZELLE =================================== //

    //Casos de uso
    final processZelleUseCase =
        ProcessZelleUseCase(paymentRepository: paymentRepository);

    getIt.registerSingleton<ProcessZelleUseCase>(processZelleUseCase);

    //Bloc
    getIt.registerSingleton(ZelleBloc(processZelleUseCase));
  }
}
