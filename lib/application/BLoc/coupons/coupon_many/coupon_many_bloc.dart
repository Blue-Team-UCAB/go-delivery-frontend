import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_delivery_frontend/application/BLoc/coupons/coupon_many/coupon_many_event.dart';
import 'package:go_delivery_frontend/application/BLoc/coupons/coupon_many/coupon_many_state.dart';
import 'package:go_delivery_frontend/application/use_cases/coupon/get_coupons.dart';
import 'package:go_delivery_frontend/common/failure.dart';
import 'package:go_delivery_frontend/common/result.dart';

class CouponListBloc extends Bloc<CouponListEvent, CouponListState> {
  final GetCouponsUseCase _getCouponsUseCase;

  CouponListBloc(this._getCouponsUseCase)
      : super(CouponListInitial()) {
    on<LoadCouponList>(_onLoadCouponList);
    on<ClearCouponList>(_onClearCouponList);
  }

  Future<void> _onLoadCouponList(
    LoadCouponList event,
    Emitter<CouponListState> emit,
  ) async {
    emit(const CouponListLoading([]));
    try {
      final result =
          await _getCouponsUseCase.execute(GetCouponsUseCaseInput());
      if (result.isSuccessful()) {
        emit(CouponListLoaded(coupons: result.getValue()));
      } else {
        emit(CouponListFailed(result));
      }
    } catch (e) {
      emit(CouponListFailed(Result.fail(const ServerFailure())));
    }
  }

  void _onClearCouponList(
    ClearCouponList event,
    Emitter<CouponListState> emit,
  ) {
    emit(CouponListInitial());
  }
}
