import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_delivery_frontend/application/BLoc/chatbot/chatbot_event.dart';
import 'package:go_delivery_frontend/application/BLoc/chatbot/chatbot_state.dart';
import 'package:go_delivery_frontend/application/use_cases/chatbot/sendmessage_use_case.dart';

class ChatBotBloc extends Bloc<ChatBotEvent, ChatBotState> {
  final SendMessageUseCase _sendMessageUseCase;
  String? _lastBotResponse;

  ChatBotBloc(this._sendMessageUseCase) : super(ChatBotInitial()) {
    on<SendMessageEvent>(_onSendMessageEvent);
  }

  Future<void> _onSendMessageEvent(
      SendMessageEvent event, Emitter<ChatBotState> emit) async {
    emit(ChatBotLoading());

    try {
      final result = await _sendMessageUseCase.execute(
        SendMessageInput(
          userId: 'user-id',
          message: event.message,
          context: event.context,
        ),
      );

      if (result.isSuccess) {
        final botResponse = result.getValue();
        if (_lastBotResponse == botResponse) {
          return;
        }
        _lastBotResponse = botResponse;

        emit(ChatBotMessageSent(
          message: event.message,
          botResponse: botResponse,
        ));
      } else {
        emit(ChatBotFailure(error: 'No se pudo enviar el mensaje'));
      }
    } catch (e) {
      emit(ChatBotFailure(error: e.toString()));
    }
  }
}
