import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/BLoc/coupon/coupon_bloc.dart';
import '../../../application/BLoc/order/order_create/order_create_bloc.dart';
import '../../../application/BLoc/order/order_create/order_create_event.dart';
import '../../../application/BLoc/order/order_create/order_create_state.dart';
import '../../../domain/entities/coupon/coupon.dart';


class CheckoutStager extends StatefulWidget {
  final Widget child;
  final CheckoutBloc checkoutBloc;
  final CouponBloc? couponBloc;

  const CheckoutStager({
    super.key,
    required this.child,
    required this.checkoutBloc,
    this.couponBloc
  });

  @override
  CheckoutStagerState createState() => CheckoutStagerState();
}

class CheckoutStagerState extends State<CheckoutStager> {
  String? _couponId;
  Coupon? _fetchedCoupon;
  bool _isLoading = false;
  String? _errorMessage;

  // One-time coupon ID getter
  String? consumeCouponId() {
    final currentCouponId = _couponId;
    _couponId = null;
    return currentCouponId;
  }

  Future<void> validateAndFetchCoupon(String couponId) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Dispatch ApplyCouponEvent to CheckoutBloc
      widget.checkoutBloc.add(ApplyCouponEvent(couponId));
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to fetch coupon';
        _isLoading = false;
      });
    }
  }

  Future<bool> processCheckout({
    required String direction,
    required double longitude,
    required double latitude,
    String? tokenStripe,
  }) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final completer = Completer<bool>();

    late StreamSubscription subscription;
    subscription = widget.checkoutBloc.stream.listen(
          (state) {
        // Check for successful order creation
        if (state.cartItems.isEmpty && state.total == 0.0) {
          setState(() {
            _isLoading = false;
          });
          completer.complete(true);
          subscription.cancel();
        }

        // Check for error
        if (state.errorMessage != null) {
          setState(() {
            _errorMessage = state.errorMessage;
            _isLoading = false;
          });
          completer.complete(false);
          subscription.cancel();
        }
      },
      onError: (error) {
        setState(() {
          _errorMessage = 'An unexpected error occurred';
          _isLoading = false;
        });
        completer.complete(false);
        subscription.cancel();
      },
      cancelOnError: true,
    );

    // Dispatch ProcessCheckoutEvent
    widget.checkoutBloc.add(ProcessCheckoutEvent(
      direction: direction,
      longitude: longitude,
      latitude: latitude,
      tokenStripe: tokenStripe,
    ));

    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CheckoutBloc, CheckoutState>(
      bloc: widget.checkoutBloc,
      listener: (context, state) {
        // Handle coupon application
        if (state.appliedCoupon != null) {
          setState(() {
            _fetchedCoupon = state.appliedCoupon;
            _isLoading = false;
          });
        }
      },
      child: Stack(
        children: [
          widget.child,
          if (_isLoading)
            const Positioned.fill(
              child: ColoredBox(
                color: Colors.black54,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          if (_errorMessage != null)
            Positioned.fill(
              child: GestureDetector(
                onTap: () => setState(() => _errorMessage = null),
                child: ColoredBox(
                  color: Colors.black54,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _errorMessage!,
                            style: const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => setState(() => _errorMessage = null),
                            child: const Text('Dismiss'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
