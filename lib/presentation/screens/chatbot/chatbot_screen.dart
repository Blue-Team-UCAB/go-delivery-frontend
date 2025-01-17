import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:go_delivery_frontend/application/BLoc/chatbot/chatbot_bloc.dart';
import 'package:go_delivery_frontend/application/BLoc/chatbot/chatbot_event.dart';
import 'package:go_delivery_frontend/application/BLoc/chatbot/chatbot_state.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatBotScreen extends StatelessWidget {
  const ChatBotScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final chatBotBloc = context.read<ChatBotBloc>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'GoDely ChatBot',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: _ChatBotView(chatBotBloc: chatBotBloc),
    );
  }
}

class _ChatBotView extends StatefulWidget {
  final ChatBotBloc chatBotBloc;

  const _ChatBotView({required this.chatBotBloc});

  @override
  _ChatBotViewState createState() => _ChatBotViewState();
}

class _ChatBotViewState extends State<_ChatBotView> {
  final List<types.Message> _messages = [];
  String? lastBotResponse;

  @override
  void initState() {
    super.initState();
    _addInitialMessage();
  }

  void _addInitialMessage() {
    final initialBotMessage = types.TextMessage(
      author: types.User(id: 'bot-id'),
      id: const Uuid().v4(),
      text: '¡Hola! ¿En qué te puedo ayudar hoy?',
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );

    setState(() {
      _messages.insert(0, initialBotMessage);
    });
  }

  void _handleSendPressed(types.PartialText message) {
    widget.chatBotBloc.add(SendMessageEvent(message: message.text));
    final userMessage = types.TextMessage(
      author: types.User(id: 'user-id'),
      id: const Uuid().v4(),
      text: message.text,
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );

    setState(() {
      _messages.insert(0, userMessage);
      _trimMessages();
    });
  }

  void _trimMessages() {
    if (_messages.length > 10) {
      _messages.removeRange(10, _messages.length);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBotBloc, ChatBotState>(
      bloc: widget.chatBotBloc,
      builder: (context, state) {
        if (state is ChatBotFailure) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          });
        }

        if (state is ChatBotMessageSent) {
          if (state.botResponse != lastBotResponse) {
            final botMessage = types.TextMessage(
              author: types.User(id: 'bot-id'),
              id: const Uuid().v4(),
              text: state.botResponse,
              createdAt: DateTime.now().millisecondsSinceEpoch,
            );

            WidgetsBinding.instance.addPostFrameCallback((_) {
              setState(() {
                _messages.insert(0, botMessage);
                lastBotResponse = state.botResponse;
                _trimMessages();
              });
            });
          }
        }

        return Chat(
          messages: _messages,
          onSendPressed: _handleSendPressed,
          user: types.User(id: 'user-id'),
          emptyState: Center(
            child: Text(
              'No hay mensajes por el momento.',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ),
        );
      },
    );
  }
}
