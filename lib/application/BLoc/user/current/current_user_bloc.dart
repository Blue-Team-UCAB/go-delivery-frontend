import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_delivery_frontend/application/use_cases/user/current/current_user_usecase_input.dart';
import 'package:go_delivery_frontend/infrastructure/models/user_model.dart';
import 'package:go_delivery_frontend/application/core/bloc/ensure_bloc.dart';
import 'package:go_delivery_frontend/application/BLoc/user/current/current_user_event.dart';
import 'package:go_delivery_frontend/application/BLoc/user/current/current_user_state.dart';

class CurrentUserBloc extends SafeBloc<CurrentUserEvent, CurrentUserState> {
  final CurrentUserUseCase currentUserUseCase;

  CurrentUserBloc({required this.currentUserUseCase})
      : super(CurrentUserInitial()) {
    on<FetchCurrentUser>(_onFetchCurrentUser);
    on<UpdateProfileImage>(_onUpdateProfileImage);
  }

  Future<void> _onFetchCurrentUser(
    FetchCurrentUser event,
    Emitter<CurrentUserState> emit,
  ) async {
    emit(CurrentUserLoading());

    final userResult = await currentUserUseCase.execute();

    if (userResult.isSuccessful()) {
      final user = userResult.getValue();

      emit(CurrentUserLoaded(
        id: user.id,
        email: user.email,
        name: user.name,
        phone: user.phone,
        image: user.image,
        type: User.userTypeToString(user.type),
      ));
    } else {
      final error = userResult.getError();
      emit(CurrentUserError(error.message));
    }
  }

  Future<void> _onUpdateProfileImage(
    UpdateProfileImage event,
    Emitter<CurrentUserState> emit,
  ) async {
    final currentState = state;
    if (currentState is CurrentUserLoaded) {
      emit(CurrentUserLoaded(
        id: currentState.id,
        email: currentState.email,
        name: currentState.name,
        phone: currentState.phone,
        image: event.imageUrl,
        type: currentState.type,
      ));
    }
  }
}
