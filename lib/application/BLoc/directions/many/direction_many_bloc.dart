import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_delivery_frontend/application/BLoc/directions/many/direction_many_event.dart';
import 'package:go_delivery_frontend/application/BLoc/directions/many/direction_many_state.dart';
import 'package:go_delivery_frontend/application/use_cases/direction/get_many/get_directions.dart';
import 'package:go_delivery_frontend/common/failure.dart';
import 'package:go_delivery_frontend/common/result.dart';

class DirectionListBloc extends Bloc<DirectionListEvent, DirectionListState> {
  final GetDirectionsUseCase _getDirectionsUseCase;

  DirectionListBloc(this._getDirectionsUseCase)
      : super(DirectionListInitial()) {
    on<LoadDirectionList>(_onLoadDirectionList);
    on<ClearDirectionList>(_onClearDirectionList);
  }

  Future<void> _onLoadDirectionList(
    LoadDirectionList event,
    Emitter<DirectionListState> emit,
  ) async {
    emit(const DirectionListLoading([]));
    try {
      final result =
          await _getDirectionsUseCase.execute(GetDirectionsUseCaseInput());
      if (result.isSuccessful()) {
        emit(DirectionListLoaded(directions: result.getValue()));
      } else {
        emit(DirectionListFailed(result));
      }
    } catch (e) {
      emit(DirectionListFailed(Result.fail(const ServerFailure())));
    }
  }

  void _onClearDirectionList(
    ClearDirectionList event,
    Emitter<DirectionListState> emit,
  ) {
    emit(DirectionListInitial());
  }
}
