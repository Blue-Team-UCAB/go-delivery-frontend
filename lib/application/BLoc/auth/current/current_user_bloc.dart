import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_delivery_frontend/application/use_cases/auth/current/current_user_usecase_input.dart';

import '../../../../infrastructure/models/user_model.dart';
import '../../../core/bloc/ensure_bloc.dart';
import 'current_user_event.dart';
import 'current_user_state.dart';

class CurrentUserBloc extends SafeBloc<CurrentUserEvent, CurrentUserState> {
  final CurrentUserUseCase currentUserUseCase;

  CurrentUserBloc({required this.currentUserUseCase})
      : super(CurrentUserInitial()) {
    on<FetchCurrentUser>(_onFetchCurrentUser);
  }

  Future<void> _onFetchCurrentUser(
    FetchCurrentUser event,
    Emitter<CurrentUserState> emit,
  ) async {
    emit(CurrentUserLoading());

    final userResult = await currentUserUseCase.execute();

    print(userResult.value!.email);

    if (userResult.isSuccessful()) {
      final user = userResult.getValue();

      emit(CurrentUserLoaded(
        id: user.id,
        email: user.email,
        name: user.name,
        phone: user.phone,
        image: user.image ?? '',
        type: User.userTypeToString(user.type),
      ));
    } else {
      final error = userResult.getError();
      emit(CurrentUserError(error.message ?? 'Unknown error occurred'));
    }
  }
}
