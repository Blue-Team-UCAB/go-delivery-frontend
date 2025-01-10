abstract class OrderReportState {}

class OrderReportInitialState extends OrderReportState {}

class OrderReportLoadingState extends OrderReportState {}

class OrderReportSuccessState extends OrderReportState {
  final bool sucess;

  OrderReportSuccessState({
    required this.sucess,
  });
}

class OrderReportErrorState extends OrderReportState {
  final String error;

  OrderReportErrorState({required this.error});
}