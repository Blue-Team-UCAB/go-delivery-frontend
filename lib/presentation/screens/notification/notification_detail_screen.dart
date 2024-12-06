import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_delivery_frontend/application/BLoc/notifications/bloc/notifications_bloc.dart';
import 'package:go_delivery_frontend/infrastructure/mappers/push_message_model.dart';

/*
class DetailsScreen extends StatelessWidget {
  final String pushMessageId;

  const DetailsScreen({super.key, required this.pushMessageId});

  @override
  Widget build(BuildContext context) {
    final PushMessageModel? message =
       context.watch<NotificationsBloc>().getMessageById(pushMessageId);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Detalles Push'),
        ),
        body: (message != null)
            ? _DetailsView(message: message)
            : const Center(child: Text('Notificación no existe')));
  }
}
// */
class _DetailsView extends StatelessWidget {
  final PushMessageModel message;

  const _DetailsView({required this.message});

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Column(
        children: [
          if (message.imageUrl != null) Image.network(message.imageUrl!),
          const SizedBox(height: 30),
          Text(message.title, style: textStyles.titleMedium),
          Text(message.body),
          const Divider(),
          Text(message.data.toString()),
        ],
      ),
    );
  }
}
