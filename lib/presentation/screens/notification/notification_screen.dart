import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_delivery_frontend/application/BLoc/notifications/bloc/notifications_bloc.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});
  @override
  Widget build(BuildContext context) {
    // final bool isDarkMode = context.watch<ThemesBloc>().isDarkMode;

    final notifications =
        context.watch<NotificationsBloc>().state.notifications;
    return Scaffold(
      // backgroundColor: isDarkMode ? Colors.black26 : const Color(0xFF02066F),
      backgroundColor: const Color(0xFFEBEAED),
      appBar: AppBar(
          // title: Text(
          //   context.select((NotificationsBloc bloc) => '${bloc.state}'),
          //   style: const TextStyle(fontSize: 10),
          // ),
          title:  Text('Notificaciones', style: TextStyle(fontFamily: "Montserrat",fontWeight: FontWeight.bold, fontSize: 26)),
          backgroundColor: const Color(0xFFEBEAED),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            final notification = notifications[notifications.length - 1 - index];
            return Column(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFFFFF),
                    borderRadius:
                        BorderRadius.all(Radius.circular(12))),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(vertical: 0,horizontal: 10),
                    title: Text(
                      notification.title,
                      style: const TextStyle(fontFamily: 'Inter',fontSize: 16, fontWeight: FontWeight.w600,color: Color(0xFF000000)),
                    ),
                    subtitle: Text(
                      notification.body,
                      style: const TextStyle(fontFamily: 'Inter',fontSize: 14, color: Color(0xFF000000)),
                    ),
                    leading: 
                    Container(width: 60,height: 60,
                      
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(100, 213, 204, 255),
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                      child:  notification.imageUrl != null
                        ? Icon(Icons.comment,color: Color(0xFF02066F))
                        : Icon(Icons.comment,color: Color(0xFF02066F),)
                    ),
                    onTap: () {
                    },
                  ),
                ),
                SizedBox(height: 8,)
              ],
            );
          },
        ),
      ),
    );
  }
}
