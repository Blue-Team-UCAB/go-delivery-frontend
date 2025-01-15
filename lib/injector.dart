import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:go_delivery_frontend/application/BLoc/blocs.dart';
import 'package:go_delivery_frontend/application/BLoc/category/category_bloc.dart';
import 'package:go_delivery_frontend/application/BLoc/coupons/coupon_many/coupon_many_bloc.dart';
import 'package:go_delivery_frontend/application/BLoc/filter/filter_bloc.dart';
import 'package:go_delivery_frontend/application/BLoc/order/courier_position/order_courier_position_bloc.dart';
import 'package:go_delivery_frontend/application/BLoc/order/order_create/order_create_bloc.dart';
import 'package:go_delivery_frontend/application/BLoc/payment/get_payment_methods/get_payment_methods_blocs.dart';
import 'package:go_delivery_frontend/application/use_cases/category/get_many_category.dart';
import 'package:go_delivery_frontend/application/BLoc/order/order_report/order_report_bloc.dart';
import 'package:go_delivery_frontend/application/use_cases/coupon/get_coupons.dart';
import 'package:go_delivery_frontend/application/use_cases/order/cancel_order.dart';
import 'package:go_delivery_frontend/application/use_cases/order/driver_position_order.dart';
import 'package:go_delivery_frontend/application/use_cases/order/report_order.dart';
import 'package:go_delivery_frontend/application/use_cases/use_cases.dart';
import 'package:go_delivery_frontend/domain/repositories/category/category_repository.dart';
import 'package:go_delivery_frontend/domain/repositories/repositories.dart';
import 'package:go_delivery_frontend/infrastructure/repositories/category/category_repository_impl.dart';
import 'package:go_delivery_frontend/infrastructure/repositories/repositories_impl.dart';
import 'package:go_delivery_frontend/application/BLoc/auth/recover_password/recover_password_bloc.dart';
import 'package:go_delivery_frontend/application/BLoc/auth/register/register_bloc.dart';
import 'package:go_delivery_frontend/application/BLoc/order/order_cancel/order_cancel_bloc.dart';
import 'package:go_delivery_frontend/application/use_cases/notification/send_device_token_usecase.dart';
import 'package:go_delivery_frontend/application/use_cases/order/create_order.dart';
import 'package:go_delivery_frontend/domain/repositories/notifications/notifications_repository.dart';
import 'package:go_delivery_frontend/infrastructure/datasources/api/api_request_impl.dart';
import 'package:go_delivery_frontend/infrastructure/datasources/cart/cart_isar_local_storage_datasource.dart';
import 'package:go_delivery_frontend/infrastructure/datasources/localstorage/localstorage_impl.dart';
import 'package:go_delivery_frontend/infrastructure/repositories/notifications/notifications_repository_impl.dart';

final getIt = GetIt.instance;

class InjectManager {
  static Future<void> setUpInjections() async {
    await dotenv.load(fileName: ".env");
    final LocalStorageService localStorageService = LocalStorageService();

    ApiRequestManagerImpl apiRequestManagerImpl;

    String? currentApiUrl =
        await localStorageService.getValue<String>("CURRENT_API_URL");

    if (currentApiUrl != null && currentApiUrl.length > 1) {
      print("CURRENT API URL: $currentApiUrl");

      apiRequestManagerImpl =
          ApiRequestManagerImpl(baseDirection: currentApiUrl);
    } else {
      apiRequestManagerImpl =
          ApiRequestManagerImpl(baseDirection: dotenv.env['API_URL']!);
    }

    // ============================= THEME =================================== //
    getIt.registerSingleton(ThemesBloc());
    // ======================================================================= //

    // ============================= AUTH ==================================== //

    final userRepository = AuthRepositoryImpl(
        apiRequestManager: apiRequestManagerImpl,
        localStorage: localStorageService);

    //caso de uso
    final loginUseCase = LoginUseCase(userRepository: userRepository);
    final registerUseCase = RegisterUseCase(userRepository: userRepository);
    final recoveryUseCase = RecoveryUseCase(userRepository: userRepository);
    final getCurrentUseCase =
        CurrentUserUseCase(userRepository: userRepository);
    final updateUserImageUseCase =
        UpdateUserImageUseCase(userRepository: userRepository);

    // Registrar
    getIt.registerFactory(() => LoginBloc(loginUseCase: loginUseCase));
    getIt.registerFactory(() => RegisterBloc(userRepository.register));
    getIt.registerSingleton(
        RecoverPasswordBloc(recoveryUseCase: recoveryUseCase));
    getIt.registerSingleton(
        CurrentUserBloc(currentUserUseCase: getCurrentUseCase));
    getIt.registerSingleton(UserImageBloc(updateUserImageUseCase));

    //registrar caso de uso
    getIt.registerSingleton<LoginUseCase>(loginUseCase);
    getIt.registerSingleton<RegisterUseCase>(registerUseCase);
    getIt.registerSingleton<RecoveryUseCase>(recoveryUseCase);
    getIt.registerSingleton<CurrentUserUseCase>(getCurrentUseCase);
    getIt.registerSingleton<UpdateUserImageUseCase>(updateUserImageUseCase);

    // ======================================================================= //

    // ============================= CART ==================================== //
    final cartLocalStorageRepo =
        CartLocalStorageRepositoryImpl(CartIsarLocalStorageDatasource());
    getIt.registerSingleton(CartBloc(cartLocalStorageRepo));
    // ======================================================================= //

    // ============================= NOTIFICATIONS =========================== //

    final notificationRepository = NotificationsRepositoryImpl(
        apiRequestManager: apiRequestManagerImpl,
        localStorage: localStorageService);

    getIt.registerSingleton<NotificationsRepository>(notificationRepository);

    final sendDeviceTokenUseCase =
        SendDeviceTokenUseCase(notificationsRepository: notificationRepository);

    getIt.registerSingleton<SendDeviceTokenUseCase>(sendDeviceTokenUseCase);

    // ======================================================================= //

    getIt.registerSingleton(NotificationsBloc(
      sendDeviceTokenUseCase: sendDeviceTokenUseCase,
    ));

    // ============================= COUPON ============================= //
    // Repositorio
    final couponRepository = CouponRepositoryImpl(
      apiRequestManager: apiRequestManagerImpl,
      localStorage: localStorageService,
    );

    // Registrar el repositorio de cupones
    getIt.registerSingleton<CouponRepository>(couponRepository);

    // Casos de Uso
    final getOneCouponUseCase =
        GetOneCouponUseCase(couponRepository: couponRepository);

    final getCouponsUseCase =
        GetCouponsUseCase(couponRepository: couponRepository);

    // Registrar el caso de uso de obtención de cupon
    getIt.registerSingleton<GetOneCouponUseCase>(getOneCouponUseCase);
    getIt.registerSingleton<GetCouponsUseCase>(getCouponsUseCase);
    getIt.registerSingleton(CouponListBloc(getCouponsUseCase));
    getIt.registerSingleton(CouponBloc(getOneCouponUseCase));
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
    final getManyOrderUseCase =
        GetManyOrdersUseCase(orderRepository: orderRepository);
    final checkoutUseCase = CheckoutUseCase(orderRepository: orderRepository);
    final cancelOneOrderUseCase =
        CancelOneOrderUseCase(orderRepository: orderRepository);
    final reportOneOrderUseCase =
        ReportOneOrderUseCase(orderRepository: orderRepository);
    final driverPositionOrderUseCase =
        GetDriverPositionOrderUseCase(orderRepository: orderRepository);

    getIt.registerSingleton<GetOneOrderUseCase>(getOneOrderUseCase);
    getIt.registerSingleton<GetManyOrdersUseCase>(getManyOrderUseCase);
    getIt.registerSingleton<CheckoutUseCase>(checkoutUseCase);
    getIt.registerSingleton<CancelOneOrderUseCase>(cancelOneOrderUseCase);
    getIt.registerFactory(
        () => OrderReportBloc(reportOrderUseCase: reportOneOrderUseCase));
    getIt.registerSingleton<GetDriverPositionOrderUseCase>(
        driverPositionOrderUseCase);

    // ======================================================================= //
    getIt.registerSingleton(
        OrderDetailBloc(getOneOrderUseCase: getOneOrderUseCase));
    getIt.registerSingleton(OrderDriverPositionBloc(
        getDriverPositionOrderUseCase: driverPositionOrderUseCase));

    // ============================= CATEGORIES ============================= //
    // Repositorio
    final categoryRepository = CategoryRepositoryImpl(
      apiRequestManager: apiRequestManagerImpl,
      localStorage: localStorageService,
    );
    // Registrar el repositorio de categorias
    getIt.registerSingleton<CategoryRepository>(categoryRepository);

    // Casos de Uso
    final getCategoriesUseCase =
        GetCategoriesUseCase(categoryRepository: categoryRepository);

    // Registrar el caso de uso de obtención de productos
    getIt.registerSingleton<GetCategoriesUseCase>(getCategoriesUseCase);

    getIt.registerSingleton(CategoryBloc(
      getCategoriesUseCase,
    ));
    // Register FilterBloc
    getIt.registerSingleton(FilterBloc());
    // ======================================================================= //
    getIt.registerSingleton(
        ManyOrdersBloc(getManyOrdersUseCase: getManyOrderUseCase));
    getIt.registerSingleton(CheckoutBloc(
        cartRepository: cartLocalStorageRepo,
        checkoutUseCase: checkoutUseCase,
        getOneCouponUseCase: getOneCouponUseCase));
    getIt.registerSingleton(
        OrderCancelBloc(cancelOrderUseCase: cancelOneOrderUseCase));

    // ============================= PAYMENT =================================== //

    //Repositorio
    final paymentRepository = PaymentRepositoryImpl(
        apiRequestManager: apiRequestManagerImpl,
        localStorage: localStorageService);

    // Registrar el repositorio de payment
    getIt.registerSingleton<PaymentRepository>(paymentRepository);

    //Caso de uso
    final getPaymentMethodsUseCase =
        GetPaymentMethodsUseCase(paymentRepository: paymentRepository);

    getIt.registerSingleton<GetPaymentMethodsUseCase>(getPaymentMethodsUseCase);

    //Bloc
    getIt.registerSingleton(PaymentMethodBloc(getPaymentMethodsUseCase));

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

    // ============================= CARD =================================== //

    //Casos de uso
    final processCardUseCase =
        ProcessCardPaymentUseCase(paymentRepository: paymentRepository);

    final getCardUseCase =
        GetUserCardsUseCase(paymentRepository: paymentRepository);

    final deleteCardUseCase =
        DeleteCardUseCase(paymentRepository: paymentRepository);

    getIt.registerSingleton<ProcessCardPaymentUseCase>(processCardUseCase);
    getIt.registerSingleton<GetUserCardsUseCase>(getCardUseCase);
    getIt.registerSingleton<DeleteCardUseCase>(deleteCardUseCase);

    //Bloc
    getIt.registerSingleton(CardBloc(processCardUseCase));
    getIt.registerSingleton(CardListBloc(getCardUseCase));
    getIt.registerSingleton(DeleteCardBloc(deleteCardUseCase));

    // ============================= WALLET =================================== //

    //Repositorio
    final walletRepository = WalletRepositoryImpl(
        apiRequestManager: apiRequestManagerImpl,
        localStorage: localStorageService);

    //Caso de uso
    final getWalletAmountUseCase =
        GetWalletAmountUseCase(walletRepository: walletRepository);

    final getPaymentTransactionsUseCase =
        GetPaymentTransactionsUseCase(walletRepository: walletRepository);

    getIt.registerSingleton<GetWalletAmountUseCase>(getWalletAmountUseCase);
    getIt.registerSingleton<GetPaymentTransactionsUseCase>(
        getPaymentTransactionsUseCase);

    //Bloc
    getIt.registerSingleton(GetWalletAmountBloc(getWalletAmountUseCase));
    getIt.registerSingleton(
        GetPaymentTransactionsBloc(getPaymentTransactionsUseCase));

    // ============================= DIRECTIONS =================================== //

    //Repositorio
    final directionRepository = DirectionRepositoryImpl(
        apiRequestManager: apiRequestManagerImpl,
        localStorage: localStorageService);

    //Casos de uso
    final getDirectionsUseCase =
        GetDirectionsUseCase(directionRepository: directionRepository);
    final addDirectionUseCase =
        AddDirectionUseCase(directionRepository: directionRepository);
    final updateDirectionUseCase =
        UpdateDirectionUseCase(directionRepository: directionRepository);
    final deleteAddressUseCase =
        DeleteAddressUseCase(directionRepository: directionRepository);

    getIt.registerSingleton<GetDirectionsUseCase>(getDirectionsUseCase);
    getIt.registerSingleton<AddDirectionUseCase>(addDirectionUseCase);
    getIt.registerSingleton<UpdateDirectionUseCase>(updateDirectionUseCase);
    getIt.registerSingleton<DeleteAddressUseCase>(deleteAddressUseCase);

    //Blocs
    getIt.registerSingleton(DirectionListBloc(getDirectionsUseCase));
    getIt.registerSingleton(AddDirectionBloc(addDirectionUseCase));
    getIt.registerSingleton(UpdateDirectionBloc(updateDirectionUseCase));
    getIt.registerSingleton(DeleteAddressBloc(deleteAddressUseCase));
  }
}
