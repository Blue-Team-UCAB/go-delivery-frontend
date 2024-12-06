import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:go_delivery_frontend/common/result.dart';
import 'package:go_delivery_frontend/common/failure.dart';
import 'package:go_delivery_frontend/application/use_cases/coupon/get_one_coupon.dart';
import 'package:go_delivery_frontend/domain/entities/coupon/coupon.dart';


part 'coupon_event.dart';
part 'coupon_state.dart';

class CouponBloc extends Bloc<CouponEvent, CouponState> {
  final GetOneCouponUseCase _getOneCouponUseCase;

  CouponBloc(this._getOneCouponUseCase)
      : super(CouponInitial()) {
    on<LoadCoupon>(_onLoadCoupon);
  }

  Future<void> _onLoadCoupon(
    LoadCoupon event,
    Emitter<CouponState> emit,
  ) async {
    if (state is CouponInitial || state is CouponLoaded) {
      try {
        final currentState = state is CouponLoaded
            ? state
            : const CouponLoading( Coupon(id: '',porcentage: 0));

        emit(CouponLoading(currentState.coupon!));

        final result = await _getOneCouponUseCase.execute(
          GetOneCouponUseCaseInput(couponId: event.couponId),
        );

        if (result.isSuccessful()) {
          final coupon = result.getValue();
          emit(CouponLoaded(coupon));
        } else {
          emit(const CouponLoaded(Coupon(id: '',porcentage: 0)));
        }
      } catch (e) {
        print('Error in CouponBloc: $e');
        // emit(CouponFailed(Result.fail(e.toString() as Failure)));
      }
    }
  }
}
