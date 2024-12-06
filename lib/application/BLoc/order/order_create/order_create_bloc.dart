import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_delivery_frontend/application/use_cases/order/create_order.dart';
import 'package:go_delivery_frontend/domain/repositories/cart/cart_local_storage_repository.dart';
import '../../../../domain/entities/product/product.dart';
import '../../../../domain/repositories/order/order_repository.dart';
import '../../../use_cases/coupon/get_one_coupon.dart';
import 'order_create_event.dart';
import 'order_create_state.dart';

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  final CartLocalStorageRepository _cartRepository;
  final CheckoutUseCase _checkoutUseCase;
  final GetOneCouponUseCase _getOneCouponUseCase;

  CheckoutBloc({
    required CartLocalStorageRepository cartRepository,
    required CheckoutUseCase checkoutUseCase,
    required GetOneCouponUseCase getOneCouponUseCase,
  })  : _cartRepository = cartRepository,
        _checkoutUseCase = checkoutUseCase,
        _getOneCouponUseCase = getOneCouponUseCase,
        super(const CheckoutState()) {
    on<LoadCartItemsEvent>(_onLoadCartItems);
    on<ApplyCouponEvent>(_onApplyCoupon);
    on<ProcessCheckoutEvent>(_onProcessCheckout);
  }

  Future<void> _onLoadCartItems(
      LoadCartItemsEvent event,
      Emitter<CheckoutState> emit,
      ) async {
    try {
      emit(state.copyWith(status: CheckoutStatus.loading));

      final cartItems = await _cartRepository.loadCartItems();

      double total = 0.0;
      for (var item in cartItems) {
        total += item.price * item.quantity;
      }

      emit(state.copyWith(
        status: CheckoutStatus.initial,
        cartItems: cartItems,
        total: total,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: CheckoutStatus.failure,
        errorMessage: 'Failed to load cart items',
      ));
    }
  }

  Future<void> _onApplyCoupon(
      ApplyCouponEvent event,
      Emitter<CheckoutState> emit,
      ) async {
    try {
      emit(state.copyWith(status: CheckoutStatus.loading));

      // Fetch coupon
      final input = GetOneCouponUseCaseInput(couponId: event.couponId);
      final couponResult = await _getOneCouponUseCase.execute(input);

      if (!couponResult.isSuccessful()) {
        // Handling failure
        emit(state.copyWith(
          status: CheckoutStatus.failure,
          errorMessage: couponResult.getError().message ?? 'Invalid coupon',
        ));
      } else {
        // Handling success
        final coupon = couponResult.getValue();

        // Apply percentage coupon logic
        double discountedTotal = state.total * (1 - (coupon.porcentage / 100));

        emit(state.copyWith(
          status: CheckoutStatus.initial,
          appliedCoupon: coupon,
          total: discountedTotal,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: CheckoutStatus.failure,
        errorMessage: 'Failed to apply coupon',
      ));
    }
  }

  Future<void> _onProcessCheckout(
      ProcessCheckoutEvent event,
      Emitter<CheckoutState> emit,
      ) async {
    try {
      emit(state.copyWith(status: CheckoutStatus.loading));

      // Validate required information
      if (state.cartItems.isEmpty) {
        emit(state.copyWith(
          status: CheckoutStatus.failure,
          errorMessage: 'Cart is empty',
        ));
        return;
      }

      if (state.direction == null ||
          state.longitude == null ||
          state.latitude == null) {
        emit(state.copyWith(
          status: CheckoutStatus.failure,
          errorMessage: 'Delivery information is incomplete',
        ));
        return;
      }

      // Prepare products
      final List<OrderProduct> products = state.cartItems
          .map((item) => OrderProduct(
        id: item.id,
        name: item.name,
        price: item.price,
        quantity: item.quantity,
        imageUrl: item.imgUrl,
      ))
          .toList();

      // Prepare checkout input
      final checkoutInput = CheckoutUseCaseInput(
        direction: state.direction!,
        longitude: state.longitude!,
        latitude: state.latitude!,
        tokenStripe: event.tokenStripe,
        idCoupon: state.appliedCoupon?.id,
        products: products,
      );

      // Execute checkout use case
      final orderResult = await _checkoutUseCase.execute(checkoutInput);

      // Handle order creation result
      if (!orderResult.isSuccessful()) {
        // Handling failure
        emit(state.copyWith(
          status: CheckoutStatus.failure,
          errorMessage: orderResult.getError().message ?? 'Failed to create order',
        ));
      } else {
        // Handling success
        final order = orderResult.getValue();

        // Clear cart after successful order
        await _cartRepository.emptyCart();

        emit(state.copyWith(
          status: CheckoutStatus.success,
          cartItems: [],
          total: 0.0,
          appliedCoupon: null,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: CheckoutStatus.failure,
        errorMessage: 'Failed to process checkout',
      ));
    }
  }
}