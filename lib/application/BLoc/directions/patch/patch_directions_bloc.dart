import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_delivery_frontend/application/BLoc/directions/add/add_direction_event.dart';
import 'package:go_delivery_frontend/application/BLoc/directions/add/add_direction_state.dart';
import 'package:go_delivery_frontend/application/BLoc/directions/patch/patch_directions_event.dart';
import 'package:go_delivery_frontend/application/BLoc/directions/patch/patch_directions_state.dart';
import 'package:go_delivery_frontend/application/use_cases/direction/patch/patch_direction.dart';

class UpdateDirectionBloc extends Bloc<DirectionEvent, DirectionState> {
  final UpdateDirectionUseCase _updateDirectionUseCase;

  UpdateDirectionBloc(this._updateDirectionUseCase)
      : super(DirectionInitial()) {
    on<UpdateDirection>(_onUpdateDirection);
  }

  Future<void> _onUpdateDirection(
      UpdateDirection event, Emitter<DirectionState> emit) async {
    emit(DirectionLoading());
    try {
      final result = await _updateDirectionUseCase.execute(UpdateDirectionInput(
        directionId: event.directionId,
        name: event.name,
        direction: event.direction,
        lat: event.lat,
        long: event.long,
        favorite: event.favorite,
      ));

      if (result.isSuccessful()) {
        emit(DirectionUpdated(direction: result.getValue()));
      } else {
        final error = result.getError();
        emit(DirectionFailure(message: error.message));
      }
    } catch (e) {
      emit(DirectionFailure(message: "Error al actualizar la dirección: $e"));
    }
  }
}
