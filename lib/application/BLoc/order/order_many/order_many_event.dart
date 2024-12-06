abstract class ManyOrdersEvent {}

class LoadManyOrdersEvent extends ManyOrdersEvent {
  final int page;
  final int perpage;
  final String status;

  LoadManyOrdersEvent({
    required this.page,
    required this.perpage,
    required this.status,
  });
}