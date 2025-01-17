import 'package:equatable/equatable.dart';

abstract class ChatBotState extends Equatable {
  const ChatBotState();

  @override
  List<Object?> get props => [];
}

class ChatBotInitial extends ChatBotState {}

class ChatBotLoading extends ChatBotState {}

class ChatBotMessageSent extends ChatBotState {
  final String message;
  final String botResponse;

  const ChatBotMessageSent({
    required this.message,
    required this.botResponse,
  });

  @override
  List<Object?> get props => [message, botResponse];
}

class ChatBotFailure extends ChatBotState {
  final String error;

  const ChatBotFailure({required this.error});

  @override
  List<Object?> get props => [error];
}
