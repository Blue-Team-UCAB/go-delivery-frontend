import 'package:equatable/equatable.dart';

abstract class CouponListEvent extends Equatable {
  const CouponListEvent();
}

class LoadCouponList extends CouponListEvent {
  @override
  List<Object?> get props => [];
}

class ClearCouponList extends CouponListEvent {
  @override
  List<Object?> get props => [];
}
