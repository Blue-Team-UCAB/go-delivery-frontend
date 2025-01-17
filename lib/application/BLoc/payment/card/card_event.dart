import 'package:equatable/equatable.dart';

abstract class CardEvent extends Equatable {
  const CardEvent();
}

class SubmitCardPayment extends CardEvent {
  final String idCard;

  const SubmitCardPayment({
    required this.idCard,
  });

  @override
  List<Object?> get props => [idCard];
}
