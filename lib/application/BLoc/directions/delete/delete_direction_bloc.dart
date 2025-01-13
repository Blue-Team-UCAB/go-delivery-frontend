import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_delivery_frontend/application/BLoc/directions/delete/delete_direction_state.dart';
import 'package:go_delivery_frontend/application/BLoc/directions/delete/delte_direction_event.dart';
import 'package:go_delivery_frontend/application/use_cases/direction/delete/delete_direction.dart';
import 'package:go_delivery_frontend/common/failure.dart';
import 'package:go_delivery_frontend/common/result.dart';

class DeleteAddressBloc extends Bloc<DeleteAddressEvent, DeleteAddressState> {
  final DeleteAddressUseCase _deleteAddressUseCase;

  DeleteAddressBloc(this._deleteAddressUseCase)
      : super(DeleteAddressInitial()) {
    on<DeleteAddressRequested>(_onDeleteAddressRequested);
  }

  Future<void> _onDeleteAddressRequested(
    DeleteAddressRequested event,
    Emitter<DeleteAddressState> emit,
  ) async {
    emit(DeleteAddressLoading());
    try {
      final result = await _deleteAddressUseCase.execute(
        DeleteAddressUseCaseInput(addressId: event.addressId),
      );

      if (result.isSuccessful()) {
        emit(DeleteAddressSuccess());
      } else {
        emit(DeleteAddressFailure(
          result.error != null
              ? result
              : Result.fail(ServerFailure(message: 'Error.')),
        ));
      }
    } catch (e) {
      emit(DeleteAddressFailure(Result.fail(ServerFailure(message: '$e'))));
    }
  }
}
