import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';


class Notification {
  final String id;
  final String title;
  final String body;
  final DateTime date;
  final bool read;

  Notification({
    required this.id,
    required this.title,
    required this.body,
    required this.date,
    required this.read,
  });

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      date: DateTime.parse(json['date']),
      read: json['read'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'date': date.toIso8601String(),
      'read': read,
    };
  }
}

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  NotificationScreenState createState() => NotificationScreenState();
}

class NotificationScreenState extends State<NotificationScreen> {
  List<Notification> notifications = [];

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final notificationsData = prefs.getString('notifications');
    if (notificationsData != null) {
      final List<dynamic> decodedData = jsonDecode(notificationsData);
      setState(() {
        notifications =
            decodedData.map((data) => Notification.fromJson(data)).toList();
      });
    } else {
      // Example static notifications if nothing is saved
      notifications = [
        Notification(
          id: '1',
          title: 'Promo!',
          body: '50% de descuento para tu siguiente compra!.',
          date: DateTime.now(),
          read: false,
        ),
        Notification(
          id: '2',
          title: 'Recién llegados!',
          body: 'Échale un vistazo a nuestros productos mas recientes.',
          date: DateTime.now(),
          read: false,
        ),
        Notification(
          id: '3',
          title: 'Ofertas Navideñas!',
          body: 'Hasta 70% menos en items seleccionados!.',
          date: DateTime.now().subtract(const Duration(days: 1)),
          read: false,
        ),
        Notification(
          id: '4',
          title: 'Oferta Relámpago!',
          body: 'Oferta por tiempo limitado en electrónica.',
          date: DateTime.now().subtract(const Duration(days: 2)),
          read: false,
        ),
      ];
      _saveNotifications();
    }
  }

  Future<void> _saveNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final notificationsData =
        jsonEncode(notifications.map((n) => n.toJson()).toList());
    await prefs.setString('notifications', notificationsData);
  }

  @override
  Widget build(BuildContext context) {
    // final bool isDarkMode = context.watch<ThemesBloc>().isDarkMode;

    return Scaffold(
      // backgroundColor: isDarkMode ? Colors.black26 : const Color(0xFF02066F),
      // backgroundColor: const Color(0xFF02066F),
      appBar: AppBar(
        title: const Text('Notificaciones'),
        // backgroundColor: const Color(0xFF02066F),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
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
              trailing: Text(
                '${notification.date.day}/${notification.date.month}/${notification.date.year}',
                style: const TextStyle(fontSize: 12, color: Colors.white54),
              ),
            ),
          );
        },
      ),
    );
  }
}
