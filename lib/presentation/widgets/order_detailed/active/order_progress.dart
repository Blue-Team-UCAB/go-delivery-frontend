import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:go_delivery_frontend/presentation/widgets/order_detailed/active/timeLine_painter.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:animate_do/animate_do.dart';
import 'package:go_delivery_frontend/application/BLoc/order/order_detailed/order_detailed_state.dart';
import 'package:go_delivery_frontend/domain/entities/order/order.dart';
import 'package:go_delivery_frontend/presentation/widgets/order_detailed/active/delivery_map_order.dart';

import 'package:go_delivery_frontend/application/BLoc/order/courier_position/order_courier_position_bloc.dart';
import 'package:go_delivery_frontend/application/BLoc/order/courier_position/order_courier_position_event.dart';
import 'package:go_delivery_frontend/application/BLoc/order/courier_position/order_courier_position_state.dart';

import '../../../core/theme/theme_getter.dart';

class OrderProgress extends StatefulWidget {
  final OrderDetailLoadedState state;
  final String currentActiveState;

  const OrderProgress({
    Key? key,
    required this.state,
    required this.currentActiveState,
  }) : super(key: key);

  @override
  OrderProgressState createState() => OrderProgressState();
}

class OrderProgressState extends State<OrderProgress>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  final List<String> _stateOrder = [
    'CREATED',
    'IN PROCESS',
    'SHIPPED',
    'DELIVERED'
  ];

  OrderDriverPositionBloc? _orderDriverPositionBloc;
  LatLng? _driverLocation;
  LatLng? _destinationLocation;

  StreamSubscription? _driverPositionSubscription;
  Timer? _locationUpdateTimer;

  Key _mapKey = UniqueKey(); // Key to force map rebuild
  bool _isDriverNearDestination = false;

  @override
  void initState() {
    super.initState();

    // Initialize animation
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    // Initialize destination location
    _initializeDestinationLocation();

    // Initialize driver position bloc
    _initializeDriverPositionBloc();

    // Trigger animation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animationController.forward();
    });
  }

  void _initializeDestinationLocation() {
    try {
      _destinationLocation = LatLng(
        double.tryParse(widget.state.direction.latitude.toString()) ?? 0.0,
        double.tryParse(widget.state.direction.longitude.toString()) ?? 0.0,
      );

      print('Destination Location: $_destinationLocation');
    } catch (e) {
      print('Error initializing destination location: $e');
    }
  }

  void _initializeDriverPositionBloc() {
    try {
      _orderDriverPositionBloc = GetIt.I<OrderDriverPositionBloc>();

      _driverPositionSubscription = _orderDriverPositionBloc?.stream.listen(
            (state) {
          if (!mounted) return;

          if (state is LoadDriverPositionOrderLoadedState) {
            safeSetState(() {
              _driverLocation = LatLng(
                state.latActual,
                state.longActual,
              );

              // Check and update proximity
              final wasNearDestination = _isDriverNearDestination;
              _isDriverNearDestination = _checkDriverProximity();

              // Trigger side effects if proximity status changed
              if (_isDriverNearDestination != wasNearDestination) {
                _handleProximityChange();
              }

              // Force map rebuild by generating a new key
              _mapKey = UniqueKey();

              print('Updated Driver Location: $_driverLocation');
            });
          }
        },
        onError: (error) {
          print('Error in driver position stream: $error');
        },
        cancelOnError: false,
      );

      // Trigger initial location fetch
      _fetchInitialDriverLocation();
    } catch (e) {
      print('Error initializing driver position bloc: $e');
    }
  }

  void _fetchInitialDriverLocation() {
    if (!mounted) return;

    // Immediately fetch driver location
    _orderDriverPositionBloc?.add(
        LoadDriverPositionOrderEvent(id: widget.state.id)
    );

    // Set up periodic updates
    if(widget.currentActiveState == "SHIPPED") {
      _locationUpdateTimer = Timer.periodic(const Duration(seconds: 30), (_) {
        if (!mounted) {
          _locationUpdateTimer?.cancel();
          return;
        }

        print('Periodic driver location fetch for order: ${widget.state.id}');
        _orderDriverPositionBloc?.add(
            LoadDriverPositionOrderEvent(id: widget.state.id)
        );
      });
    }
  }

  // Safe setState method
  void safeSetState(VoidCallback callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(callback);
      }
    });
  }

  bool _checkDriverProximity() {
    if (_driverLocation == null || _destinationLocation == null) return false;

    // Very close proximity threshold (extremely small distance)
    final double veryCloseThreshold = 0.05; // 10 meters
    final double nearbyThreshold = 0.4; // 100 meters

    final distance = _calculateDistance(
      _driverLocation!.latitude,
      _driverLocation!.longitude,
      _destinationLocation!.latitude,
      _destinationLocation!.longitude,
    );

    // Check for extremely close proximity
    if (distance <= veryCloseThreshold) {
      _handleVeryCloseProximity();
      return true;
    }

    // Check for nearby proximity
    return distance <= nearbyThreshold;
  }

  void _handleVeryCloseProximity() {
    // Haptic feedback
    HapticFeedback.heavyImpact();

    // Show a more urgent notification
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('¡Tu entrega ha llegado!'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
      ),
    );

    _refreshOrderDetail();
  }

  void _refreshOrderDetail() {
    context.go('/orderdetail/${widget.state.id}');

  }

  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371; // Kilometers

    double dLat = _degreesToRadians(lat2 - lat1);
    double dLon = _degreesToRadians(lon2 - lon1);

    double a =
        sin(dLat/2) * sin(dLat/2) +
            cos(_degreesToRadians(lat1)) * cos(_degreesToRadians(lat2)) *
                sin(dLon/2) * sin(dLon/2);

    double c = 2 * atan2(sqrt(a), sqrt(1-a));
    return earthRadius * c * 1000; // Convert to meters
  }

  double _degreesToRadians(double degrees) {
    return degrees * (pi / 180);
  }

  void _handleProximityChange() {
    if (_isDriverNearDestination) {
      // Haptic feedback
      HapticFeedback.heavyImpact();

      // Show a snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('¡Tu entrega está cerca!'),
          backgroundColor: Colors.green,
        ),
      );

      // Optional: Log or send analytics event
      _logProximityEvent();
    }
  }

  void _logProximityEvent() {
    print('Driver is near destination for order: ${widget.state.id}');
  }

  @override
  void dispose() {
    // Cancel subscriptions and timers
    _driverPositionSubscription?.cancel();
    _locationUpdateTimer?.cancel();

    // Dispose animation controller
    _animationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentSecondaryThemeColor = AppThemesGetter.getSecondaryColor(context);

    return CustomPaint(
      painter: TimelineProgressPainter(
        animation: _animation,
        stateOrder: _stateOrder,
        currentActiveState: widget.currentActiveState,
        lineColor: currentSecondaryThemeColor, // Pass the color directly
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildStatusItem(
              context,
              'Orden realizada',
              _getStateDateByType('CREATED'),
              _isStateCompleted('CREATED'),
            ),
            _buildStatusItem(
              context,
              'En proceso',
              _getStateDateByType('IN PROCESS'),
              _isStateCompleted('IN PROCESS'),
            ),
            _buildStatusItem(
              context,
              'Enviando',
              _getStateDateByType('SHIPPED'),
              _isStateCompleted('SHIPPED'),
            ),
            if (_shouldShowDeliveryTracking()) _buildDeliveryItem(context),
            _buildStatusItem(
              context,
              'Orden entregada',
              _getStateDateByType('DELIVERED'),
              _isStateCompleted('DELIVERED'),
            ),
          ],
        ),
      ),
    );
  }

  // Helper methods for building UI components
  Widget _buildStatusItem(
      BuildContext context,
      String title,
      String subtitle,
      bool isCompleted, {
        Duration? customDelay,
      }) {
    final delay = customDelay ?? _calculateDelay(title, isCompleted);

    return FadeIn(
      delay: delay,
      child: _buildTimelineItem(
        context,
        title,
        subtitle,
        isCompleted: isCompleted,
      ),
    );
  }

  Duration _calculateDelay(String title, bool isCompleted) {
    final delayMap = {
      'Orden realizada': isCompleted ? 200 : 400,
      'En proceso': isCompleted ? 600 : 1000,
      'Enviando': isCompleted ? 800 : 1200,
      'Orden entregada': isCompleted ? 1400 : 2200,
    };

    return Duration(milliseconds: delayMap[title] ?? 0);
  }

  bool _shouldShowDeliveryTracking() {
    return widget.currentActiveState == 'SHIPPED' ||
        widget.currentActiveState == 'DELIVERED';
  }

  Widget _buildMapContent() {
    if (_driverLocation == null || _destinationLocation == null) {
      return const Center(
        key: ValueKey('loading'),
        child: CircularProgressIndicator(),
      );
    }

    return SizedBox(
      key: _mapKey,
      height: 220,
      child: DeliveryMap(
        driverLocation: _driverLocation!,
        destinationLocation: _destinationLocation!,
      ),
    );
  }

  Widget _buildDeliveryItem(BuildContext context) {
    final currentSecondaryThemeColor = AppThemesGetter.getSecondaryColor(context);

    return FadeIn(
      delay: const Duration(milliseconds: 1400),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 29,
                height: 29,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: currentSecondaryThemeColor,
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 21),
              ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Enviando Entrega',
                  style: TextStyle(
                    fontFamily: "Inter",
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  _isDriverNearDestination
                      ? '¡Tu conductor está cerca!'
                      : 'Tu conductor va en camino',
                  style: TextStyle(
                    fontFamily: "Inter",
                    color: _isDriverNearDestination
                        ? Colors.green
                        : Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: _buildMapContent(),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getStateDateByType(String stateType) {
    final matchingState = widget.state.state.firstWhere(
          (orderState) => orderState.state == stateType,
      orElse: () => OrderState(state: stateType, date: 'Pendiente'),
    );

    return matchingState.date;
  }

  bool _isStateCompleted(String checkState) {
    final checkStateIndex = _stateOrder.indexOf(checkState);
    final currentStateIndex = _stateOrder.indexOf(widget.currentActiveState);

    return checkStateIndex <= currentStateIndex;
  }

  Widget _buildTimelineItem(
      BuildContext context,
      String title,
      String subtitle, {
        bool isCompleted = false,
      }) {

    final currentSecondaryThemeColor = AppThemesGetter.getSecondaryColor(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCompleted ? currentSecondaryThemeColor : Colors.grey[300],
                border: Border.all(
                  color: isCompleted ? currentSecondaryThemeColor : Colors.grey[300]!,
                  width: 2,
                ),
              ),
              child: isCompleted
                  ? const Icon(Icons.check, color: Colors.white, size: 20)
                  : null,
            ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontFamily: "Inter",
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontFamily: "Inter",
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 18),
            ],
          ),
        ),
      ],
    );
  }
}