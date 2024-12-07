abstract class OrderCancelState {}

class OrderCancelInitialState extends OrderCancelState {}

class OrderCancelLoadingState extends OrderCancelState {}

class OrderCancelSuccessState extends OrderCancelState {
  final bool sucess;

  OrderCancelSuccessState({
    required this.sucess,
  });
}

class OrderCancelErrorState extends OrderCancelState {
  final String error;

  OrderCancelErrorState({required this.error});
}