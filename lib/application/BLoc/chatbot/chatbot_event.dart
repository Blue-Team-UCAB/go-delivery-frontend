import 'package:equatable/equatable.dart';

abstract class ChatBotEvent extends Equatable {
  const ChatBotEvent();
}

class SendMessageEvent extends ChatBotEvent {
  final String message;

  const SendMessageEvent({required this.message});

  @override
  List<Object?> get props => [message];
}
