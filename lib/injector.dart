import 'package:get_it/get_it.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_delivery_frontend/application/BLoc/auth/current/current_user_bloc.dart';
import 'package:go_delivery_frontend/application/BLoc/blocs.dart';
import 'package:go_delivery_frontend/application/BLoc/bundle/bundle_detail/bundle_detail_bloc.dart';
import 'package:go_delivery_frontend/application/BLoc/bundle/bundle_many/bundle_many_bloc.dart';
import 'package:go_delivery_frontend/application/BLoc/product/popular/product_popular_many_bloc.dart';
import 'package:go_delivery_frontend/application/BLoc/product/popular/random/product_random_many_bloc.dart';
import 'package:go_delivery_frontend/application/BLoc/product/product_detail/product_detail_bloc.dart';
import 'package:go_delivery_frontend/application/BLoc/product/product_many/product_many_bloc.dart';
import 'package:go_delivery_frontend/application/use_cases/auth/current/current_user_usecase_input.dart';
import 'package:go_delivery_frontend/application/use_cases/auth/recover_password/recovery_usecase_input.dart';
import 'package:go_delivery_frontend/application/use_cases/auth/register/register_usecase_input.dart';
import 'package:go_delivery_frontend/application/use_cases/bundle/get_many_bundle.dart';
import 'package:go_delivery_frontend/application/use_cases/bundle/get_one_bundle.dart';
import 'package:go_delivery_frontend/application/use_cases/product/get_one_product.dart';
import 'package:go_delivery_frontend/domain/repositories/bundle/bundle_repository.dart';
import 'package:go_delivery_frontend/infrastructure/datasources/api/api_request_impl.dart';
import 'package:go_delivery_frontend/infrastructure/datasources/localstorage/localstorage_impl.dart';
import 'package:go_delivery_frontend/domain/repositories/product/product_repository.dart';
import 'package:go_delivery_frontend/infrastructure/repositories/bundle/bundle_repository_impl.dart';
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
    final recoveryUseCase = RecoveryUseCase(userRepository: userRepository);
    final getCurrentUseCase = CurrentUserUseCase(userRepository: userRepository);

    // Registrar
    getIt.registerFactory(() => LoginBloc(loginUseCase: loginUseCase));
    getIt.registerFactory(() => RegisterBloc(userRepository.register));
    getIt.registerSingleton(RecoverPasswordBloc(recoveryUseCase: recoveryUseCase));
    getIt.registerSingleton(CurrentUserBloc(currentUserUseCase: getCurrentUseCase));

    //registrar caso de uso
    getIt.registerSingleton<LoginUseCase>(loginUseCase);
    getIt.registerSingleton<RegisterUseCase>(registerUseCase);
    getIt.registerSingleton<RecoveryUseCase>(recoveryUseCase);
    getIt.registerSingleton<CurrentUserUseCase>(getCurrentUseCase);
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
  }
}
