abstract class OrderReportEvent {}

class ReportOrderEvent extends OrderReportEvent {
  final String orderId;
  final String desc;
  ReportOrderEvent({required this.orderId, required this.desc});
}