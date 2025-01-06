import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_delivery_frontend/application/BLoc/directions/add/add_direction_event.dart';
import 'package:go_delivery_frontend/application/BLoc/directions/add/add_direction_state.dart';
import 'package:go_delivery_frontend/application/use_cases/direction/add/add_direction.dart';

class AddDirectionBloc extends Bloc<DirectionEvent, DirectionState> {
  final AddDirectionUseCase _addDirectionUseCase;

  AddDirectionBloc(this._addDirectionUseCase) : super(DirectionInitial()) {
    on<AddDirection>(_onAddDirection);
  }

  Future<void> _onAddDirection(
      AddDirection event, Emitter<DirectionState> emit) async {
    emit(DirectionLoading());
    try {
      final result = await _addDirectionUseCase.execute(AddDirectionInput(
        name: event.name,
        direction: event.direction,
        latitude: event.latitude,
        longitude: event.longitude,
      ));

      if (result.isSuccessful()) {
        emit(DirectionAdded());
      } else {
        final error = result.getError();
        emit(DirectionFailure(message: error.message));
      }
    } catch (e) {
      emit(DirectionFailure(message: "Error al agregar la dirección: $e"));
    }
  }
}
