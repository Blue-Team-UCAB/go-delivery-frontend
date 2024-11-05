import 'package:get_it/get_it.dart';

import 'application/auth/login/login_bloc.dart';
import 'application/auth/recover_password/recover_password_bloc.dart';
import 'application/auth/register/register_bloc.dart';
import 'application/notifications/bloc/notifications_bloc.dart';
import 'application/notifications/notification-list/notification_list_bloc.dart';
import 'application/themes/themes_bloc.dart';
import 'infrastructure/datasources/client/clients_datasource_impl.dart';
import 'infrastructure/datasources/notifications/notifications_datasource_impl.dart';
import 'infrastructure/datasources/user/api_user_datasource.dart';
import 'infrastructure/firebase/firebase_notifications_manager.dart';
import 'infrastructure/models/local_notifications.dart';
import 'infrastructure/local_storage/local_storage.dart';
import 'infrastructure/repositories/notifications/notifications_repository_impl.dart';
import 'infrastructure/repositories/user/user_repository_impl.dart';


final getIt = GetIt.instance;

class Injector {
  void setUp() {
    final LocalStorageService localStorageService = LocalStorageService();

    final apiUserDatasource = APIUserDatasource();

    final userRepositoryImpl = UserRepositoryImpl(
        userDatasource: apiUserDatasource,
        keyValueStorage: localStorageService);
    //final notificationsRepositoryImpl = NotificationRespositoryImpl(
    //    notificationsDatasource:
    //        NotificationsDatasourceImpl(localStorageService));


    getIt.registerFactory(() =>
        RegisterBloc(userRepositoryImpl.register));
    getIt.registerFactory(() =>
        LoginBloc(userRespository: userRepositoryImpl));
    //getIt.registerFactory(() =>
    //    NotificationListBloc(notificationsRepository: notificationsRepositoryImpl));
    getIt.registerSingleton(ThemesBloc());
    //getIt.registerSingleton(NotificationsBloc(
    //    FirebaseNotificationsManager(LocalNotifications()),
    //    notificationsRepositoryImpl.saveToken));
    getIt.registerSingleton(
        RecoverPasswordBloc(userRespository: userRepositoryImpl));

  }
}