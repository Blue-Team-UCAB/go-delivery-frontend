import 'package:go_delivery_frontend/common/result.dart';
import 'package:go_delivery_frontend/common/use_cases.dart';
import 'package:go_delivery_frontend/infrastructure/repositories/chatbot/chat_bot_repository_impl.dart';

class SendMessageInput extends IUseCaseInput {
  final String userId;
  final String message;

  SendMessageInput({
    required this.userId,
    required this.message,
  });
}

class SendMessageUseCase {
  final ChatBotRepository _chatBotRepository;

  SendMessageUseCase({required ChatBotRepository chatBotRepository})
      : _chatBotRepository = chatBotRepository;

  Future<Result<String>> execute(SendMessageInput input) {
    return _chatBotRepository.sendMessage(
      userId: input.userId,
      message: input.message,
    );
  }
}
