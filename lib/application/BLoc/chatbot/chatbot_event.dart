import 'package:equatable/equatable.dart';

abstract class ChatBotEvent extends Equatable {
  const ChatBotEvent();
}

class SendMessageEvent extends ChatBotEvent {
  final String message;
  final String? context;

  const SendMessageEvent({required this.message, this.context});

  @override
  List<Object?> get props => [message, context];
}

class ResetChatEvent extends ChatBotEvent {
  @override
  List<Object?> get props => [];
}
