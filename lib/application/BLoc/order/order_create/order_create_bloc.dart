import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:go_delivery_frontend/domain/entities/cart/cartitem.dart';
import 'package:go_delivery_frontend/domain/repositories/cart/cart_local_storage_repository.dart';
import 'package:go_delivery_frontend/application/core/bloc/ensure_bloc.dart';
import 'package:go_delivery_frontend/application/use_cases/coupon/get_one_coupon.dart';
import 'package:go_delivery_frontend/application/use_cases/order/create_order.dart';
import 'package:go_delivery_frontend/application/BLoc/order/order_create/order_create_event.dart';
import 'package:go_delivery_frontend/application/BLoc/order/order_create/order_create_state.dart';

class CheckoutBloc extends SafeBloc<CheckoutEvent, CheckoutState> {
  final CartLocalStorageRepository cartRepository;
  final CheckoutUseCase _checkoutUseCase;
  final GetOneCouponUseCase _getOneCouponUseCase;

  CheckoutBloc({
    required this.cartRepository,
    required CheckoutUseCase checkoutUseCase,
    required GetOneCouponUseCase getOneCouponUseCase,
  })  : _checkoutUseCase = checkoutUseCase,
        _getOneCouponUseCase = getOneCouponUseCase,
        super(CheckoutInitial()) {
    on<LoadCartItemsEvent>(_onLoadCartItems);
    on<ApplyCouponEvent>(_onApplyCoupon);
    on<ProcessCheckoutEvent>(_onProcessCheckout);
  }

  Future<void> _onLoadCartItems(
    LoadCartItemsEvent event,
    Emitter<CheckoutState> emit,
  ) async {
    try {
      emit(CheckoutLoading());

      final cartItems = await cartRepository.loadCartItems();

      // Segregate items by type
      final List<CartItem> productItems =
          cartItems.where((item) => item.type == 'product').toList();

      final List<CartItem> bundleItems =
          cartItems.where((item) => item.type == 'bundle').toList();

      // Calculate total for product items
      double productTotal = 0.0;
      for (var item in productItems) {
        productTotal += item.price * item.quantity;
      }

      // Calculate total for bundle items
      double bundleTotal = 0.0;
      for (var item in bundleItems) {
        bundleTotal += item.price * item.quantity;
      }

      // Calculate overall total
      double total = productTotal + bundleTotal;

      emit(state.copyWith(
        cartItems: cartItems,
        productItems: productItems,
        bundleItems: bundleItems,
        productTotal: productTotal,
        bundleTotal: bundleTotal,
        total: total,
      ));
    } catch (e) {
      emit(state.copyWith(
        errorMessage: 'Failed to load cart items',
      ));
    }
  }

  Future<void> _onApplyCoupon(
    ApplyCouponEvent event,
    Emitter<CheckoutState> emit,
  ) async {
    try {
      // Fetch coupon
      final input =
          GetOneCouponUseCaseInput(couponId: event.couponId);
      final result = await _getOneCouponUseCase.execute(input);

      if (result.isSuccessful()) {
        final coupon = result.getValue();

        // Calculate discounted total
        double discountedTotal = state.total * (1 - (coupon.porcentage / 100));

        print(state.appliedCoupon!.id);
        print(discountedTotal);
        print(state.cartItems.length);
        print(state.productItems.length);
        print(state.bundleItems.length);
        print("productTotal: ${state.productTotal}");
        print("productTotal: ${state.bundleTotal}");


        // Emit coupon applied state
        emit(CheckoutCouponApplied(
          coupon: state.appliedCoupon!,
          discountedTotal: discountedTotal,
          cartItems: state.cartItems,
          productItems: state.productItems,
          bundleItems: state.bundleItems,
          productTotal: state.productTotal,
          bundleTotal: state.bundleTotal,
        ));
      } else {
        // Emit coupon error state
        emit(CheckoutCouponError(
          couponErrorMessage: 'Coupon is not valid',
          cartItems: state.cartItems,
          productItems: state.productItems,
          bundleItems: state.bundleItems,
          total: state.total,
          productTotal: state.productTotal,
          bundleTotal: state.bundleTotal,
        ));
      }
    } catch (e) {
      // Emit error state if an exception occurs
      emit(CheckoutCouponError(
        couponErrorMessage: 'Error applying coupon: ${e.toString()}',
        cartItems: state.cartItems,
        productItems: state.productItems,
        bundleItems: state.bundleItems,
        total: state.total,
        productTotal: state.productTotal,
        bundleTotal: state.bundleTotal,
      ));
    }
  }

  Future<void> _onProcessCheckout(
      ProcessCheckoutEvent event,
      Emitter<CheckoutState> emit,
      ) async {
    try {
      emit(CheckoutLoading());

      final checkoutInput = CheckoutUseCaseInput(
        paymentId: event.paymentId,
        stripePaymentMethod: event.stripePaymentMethod,
        paymentMethod: event.paymentMethod,
        couponId: event.couponId,
        idUserDirection: event.idUserDirection,
        productItems: event.productItems!,
        bundleItems: event.bundleItems,
      );

      final orderResult = await _checkoutUseCase.execute(checkoutInput);

      if (!orderResult.isSuccessful()) {
        emit(state.copyWith(
          errorMessage: orderResult.getError().message,
        ));
      } else {
        // Directly emit CheckoutSuccess with the order ID
        emit(CheckoutSuccess(id: orderResult.value!.id));
      }
    } catch (e) {
      emit(state.copyWith(
        errorMessage: 'Failed to process checkout: ${e.toString()}',
      ));
    }
  }
}
