import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_delivery_frontend/application/BLoc/user/update_image/update_image_event.dart';
import 'package:go_delivery_frontend/application/BLoc/user/update_image/update_image_state.dart';
import 'package:go_delivery_frontend/application/use_cases/user/update_image/update_image_usecase.dart';
import 'package:go_delivery_frontend/common/failure.dart';
import 'package:go_delivery_frontend/common/result.dart';

class UserImageBloc extends Bloc<UserImageEvent, UserImageState> {
  final UpdateUserImageUseCase _updateUserImageUseCase;

  UserImageBloc(this._updateUserImageUseCase) : super(UserImageInitial()) {
    on<UpdateUserImage>(_onUpdateUserImage);
  }

  Future<void> _onUpdateUserImage(
    UpdateUserImage event,
    Emitter<UserImageState> emit,
  ) async {
    emit(UserImageLoading());

    try {
      final result = await _updateUserImageUseCase
          .execute(UpdateUserImageUseCaseInput(image: event.image));

      if (result.isSuccessful()) {
        emit(UserImageSuccess());
      } else {
        emit(UserImageFailure(Result.fail(const ServerFailure()) as String));
      }
    } catch (e) {
      emit(UserImageFailure('Ocurrió un error: $e'));
    }
  }
}
