import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_delivery_frontend/application/BLoc/payment/delete_card/delete_card_event.dart';
import 'package:go_delivery_frontend/application/BLoc/payment/delete_card/delete_card_state.dart';
import 'package:go_delivery_frontend/application/use_cases/payment/delete_card.dart';
import 'package:go_delivery_frontend/common/failure.dart';
import 'package:go_delivery_frontend/common/result.dart';

class DeleteCardBloc extends Bloc<DeleteCardEvent, DeleteCardState> {
  final DeleteCardUseCase _deleteCardUseCase;

  DeleteCardBloc(this._deleteCardUseCase) : super(DeleteCardInitial()) {
    on<DeleteCardRequested>(_onDeleteCardRequested);
  }

  Future<void> _onDeleteCardRequested(
    DeleteCardRequested event,
    Emitter<DeleteCardState> emit,
  ) async {
    emit(DeleteCardLoading());
    try {
      final result = await _deleteCardUseCase.execute(
        DeleteCardUseCaseInput(cardId: event.cardId),
      );

      if (result.isSuccessful()) {
        emit(DeleteCardSuccess());
      } else {
        emit(DeleteCardFailure(result));
      }
    } catch (e) {
      emit(DeleteCardFailure(Result.fail(ServerFailure(message: '$e'))));
    }
  }
}
