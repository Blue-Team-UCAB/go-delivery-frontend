import 'package:flutter/material.dart';
import 'package:go_delivery_frontend/injector.dart';
import 'package:go_delivery_frontend/presentation/screens/catalog/catalog.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await InjectManager.setUpInjections();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Go Delivery',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
    );
  }
}
