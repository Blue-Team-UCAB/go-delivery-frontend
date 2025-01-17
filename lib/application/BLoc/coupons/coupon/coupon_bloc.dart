import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_delivery_frontend/application/use_cases/coupon/claim_one_coupon.dart';
import 'package:go_delivery_frontend/domain/entities/coupon/coupon.dart';

part 'coupon_event.dart';
part 'coupon_state.dart';

class CouponBloc extends Bloc<CouponEvent, CouponState> {
  final ClaimOneCouponUseCase _claimOneCouponUseCase;

  CouponBloc(this._claimOneCouponUseCase) : super(CouponInitial()) {
    on<ClaimCoupon>(_onClaimCoupon);
    on<ClearCoupon>(_clearCouponHandler);
    on<LoadCoupon>(_onLoadCoupon);
  }

  void clearCoupon() {
    add(const ClearCoupon());
  }

  void _clearCouponHandler(ClearCoupon event, Emitter<CouponState> emit) {
    emit(CouponInitial());
  }

  Future<void> _onClaimCoupon(
    ClaimCoupon event,
    Emitter<CouponState> emit,
  ) async {
    if (state is CouponInitial ||
        state is CouponLoaded ||
        state is CouponFailed) {
      try {
        final currentState = state is CouponLoaded
            ? state
            : CouponLoading(Coupon(id: '', porcentage: 0));

        emit(CouponLoading(currentState.coupon));

        final result = await _claimOneCouponUseCase.execute(
          ClaimOneCouponUseCaseInput(couponId: event.couponId.toUpperCase()),
        );

        if (result.isSuccessful()) {
          final coupon = result.getValue();
          add(LoadCoupon(coupon: coupon));
        } else {
          emit(CouponFailed(Coupon(id: '', porcentage: 0)));
        }
      } catch (e) {
        print('Error in CouponBloc: $e');
      }
    }
  }

  void _onLoadCoupon(LoadCoupon event, Emitter<CouponState> emit) {
    emit(CouponLoaded(event.coupon));
  }
}
