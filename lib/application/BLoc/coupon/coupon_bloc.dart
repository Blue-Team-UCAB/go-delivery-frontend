import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_delivery_frontend/application/use_cases/coupon/get_one_coupon.dart';
import 'package:go_delivery_frontend/domain/entities/coupon/coupon.dart';

part 'coupon_event.dart';
part 'coupon_state.dart';

class CouponBloc extends Bloc<CouponEvent, CouponState> {
  final GetOneCouponUseCase _getOneCouponUseCase;

  CouponBloc(this._getOneCouponUseCase) : super(CouponInitial()) {
    on<LoadCoupon>(_onLoadCoupon);
    on<ClearCoupon>(_clearCouponHandler);
  }

  void clearCoupon() {
    add(const ClearCoupon());
  }

  void _clearCouponHandler(ClearCoupon event, Emitter<CouponState> emit) {
    emit(CouponInitial());
  }

  Future<void> _onLoadCoupon(
    LoadCoupon event,
    Emitter<CouponState> emit,
  ) async {
    if (state is CouponInitial ||
        state is CouponLoaded ||
        state is CouponFailed) {
      try {
        final currentState = state is CouponLoaded
            ? state
            : const CouponLoading(Coupon(id: '', porcentage: 0));

        emit(CouponLoading(currentState.coupon));

        final result = await _getOneCouponUseCase.execute(
          GetOneCouponUseCaseInput(couponId: event.couponId.toUpperCase()),
        );

        if (result.isSuccessful()) {
          final coupon = result.getValue();
          emit(CouponLoaded(coupon));
        } else {
          emit(const CouponFailed(Coupon(id: '', porcentage: 0)));
        }
      } catch (e) {
        print('Error in CouponBloc: $e');
      }
    }
  }
}
