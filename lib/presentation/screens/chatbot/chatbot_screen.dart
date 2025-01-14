import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:uuid/uuid.dart';

class ChatBotScreen extends StatefulWidget {
  const ChatBotScreen({super.key});

  @override
  ChatBotScreenState createState() => ChatBotScreenState();
}

class ChatBotScreenState extends State<ChatBotScreen> {
  final List<types.Message> _messages = [];
  final _user = const types.User(id: 'user-id');
  final _bot = const types.User(id: 'bot-id');

  Future<void> _sendMessageToBackend(String text) async {
    await Future.delayed(const Duration(seconds: 1));
    String botMessage = "No entendí eso, pero puedes intentar otra cosa.";
    if (text.toLowerCase().contains('hola')) {
      botMessage = "¡Hola! ¿Cómo estás?";
    } else if (text.toLowerCase().contains('ayuda')) {
      botMessage = "Claro, ¿en qué puedo ayudarte?";
    } else if (text.toLowerCase().contains('adiós')) {
      botMessage = "¡Hasta luego! 😊";
    }

    final botResponse = types.TextMessage(
      author: _bot,
      id: const Uuid().v4(),
      text: botMessage,
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );

    setState(() {
      _messages.insert(0, botResponse);
    });
  }

  void _handleSendPressed(types.PartialText message) {
    final userMessage = types.TextMessage(
      author: _user,
      id: const Uuid().v4(),
      text: message.text,
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );

    setState(() {
      _messages.insert(0, userMessage);
    });

    _sendMessageToBackend(message.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF2000B1),
        title: const Text(
          'GoDely Chat',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Chat(
        messages: _messages,
        onSendPressed: _handleSendPressed,
        user: _user,
      ),
    );
  }
}
