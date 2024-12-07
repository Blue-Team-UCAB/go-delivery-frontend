import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_delivery_frontend/application/BLoc/notifications/bloc/notifications_bloc.dart';
import 'package:go_router/go_router.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});
  @override
  Widget build(BuildContext context) {
    // final bool isDarkMode = context.watch<ThemesBloc>().isDarkMode;

    final notifications =
        context.watch<NotificationsBloc>().state.notifications;
    return Scaffold(
      // backgroundColor: isDarkMode ? Colors.black26 : const Color(0xFF02066F),
      // backgroundColor: const Color(0xFF02066F),
      appBar: AppBar(
          // title: Text(
          //   context.select((NotificationsBloc bloc) => '${bloc.state}'),
          //   style: const TextStyle(fontSize: 10),
          // ),
          title: const Text('Notificaciones'),
          // backgroundColor: const Color(0xFF02066F),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            IconButton(
                onPressed: () {
                  context
                      .read<NotificationsBloc>()
                      .add(RequestNotificationPermissionEvent());
                },
                icon: const Icon(Icons.settings))
          ]),
      body: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[notifications.length - 1 - index];
          return Card(
            color: const Color(0xFF02066F),
            child: ListTile(
              title: Text(
                notification.title,
                style: const TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                notification.body,
                style: const TextStyle(color: Colors.white70),
              ),
              leading: notification.imageUrl != null
                  ? Image.network(notification.imageUrl!)
                  : null,
              onTap: () {
                context.push(
                    '/push-details/${Uri.encodeComponent(notification.messageId)}');
              },
            ),
          );
        },
      ),
    );
  }
}
