import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_delivery_frontend/application/BLoc/payment/card_get/get_card_event.dart';
import 'package:go_delivery_frontend/application/BLoc/payment/card_get/get_card_state.dart';
import 'package:go_delivery_frontend/application/use_cases/payment/get_cards.dart';
import 'package:go_delivery_frontend/common/failure.dart';
import 'package:go_delivery_frontend/common/result.dart';

class CardListBloc extends Bloc<CardListEvent, CardListState> {
  final GetUserCardsUseCase _getCardsUseCase;

  CardListBloc(this._getCardsUseCase) : super(CardListInitial()) {
    on<LoadCardList>(_onLoadCardList);
  }

  Future<void> _onLoadCardList(
    LoadCardList event,
    Emitter<CardListState> emit,
  ) async {
    emit(CardListLoading());
    try {
      final result = await _getCardsUseCase.execute(GetCardUseCaseInput());
      if (result.isSuccessful()) {
        emit(CardListLoaded(cards: result.getValue()));
      } else {
        emit(CardListFailed(result));
      }
    } catch (e) {
      emit(CardListFailed(Result.fail(const ServerFailure())));
    }
  }
}
